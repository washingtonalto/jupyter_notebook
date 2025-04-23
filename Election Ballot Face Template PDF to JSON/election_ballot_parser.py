#!/usr/bin/env python
# coding: utf-8
# election_ballot_parser.py

"""
Election Ballot Parser

This script processes Philippine election ballot PDFs and extracts structured JSON data containing
metadata, bilingual instructions, and candidates per position.

Key Features:
- Uses pdfminer with layout analysis (LAParams) for accurate left-to-right, top-to-bottom text extraction.
- Handles edge cases such as lone candidates or multi-line candidate entries.
- Designed for the 2025 Philippine elections with fixed reference data for Senators and Party List.
- Object-Oriented: Each PDF processed by BallotProcessor; entire folder by BatchProcessor.
"""

import os
import json
import re
from pathlib import Path
from pdfminer.high_level import extract_text
from pdfminer.layout import LAParams
from tqdm import tqdm

class BallotProcessor:
    """
    Processes a single election ballot PDF and generates a JSON file with structured candidate data.

    Args:
        senator_file (str): Path to JSON file containing all senator candidates.
        partylist_file (str): Path to JSON file containing all party list candidates.
    """
    def __init__(self, senator_file, partylist_file):
        with open(senator_file, 'r', encoding='utf-8') as f:
            self.senators = json.load(f)
        with open(partylist_file, 'r', encoding='utf-8') as f:
            self.partylist = json.load(f)

        self.default_instructions = {
            "english": "Mark the inside of the circle beside the name of the desired candidate.",
            "filipino": "Markahan ang loob ng bilog sa tabi ng nais ibotong kandidato."
        }

    def process_pdf(self, pdf_path, output_path):
        """
        Extracts text from the PDF and builds a structured JSON representation of its content.

        Args:
            pdf_path (str or Path): Input PDF file path.
            output_path (str or Path): Output JSON file path.
        """
        laparams = LAParams(boxes_flow=None)  # Ensures correct reading order even for lone candidates
        text = extract_text(pdf_path, laparams=laparams)

        # Metadata extraction
        location_match = re.search(r"([A-Z\u00D1, ]+CITY.*?)\n", text)
        location = location_match.group(1).strip() if location_match else "UNKNOWN"

        clustered_precinct_id_match = re.search(r"Clustered Precinct ID:\s*(\w+)", text)
        clustered_precinct_id = clustered_precinct_id_match.group(1) if clustered_precinct_id_match else "UNKNOWN"

        precincts = []
        precinct_match = re.search(r"Precincts in Cluster:\s*([\s\S]*?)\n\n", text)
        if precinct_match:
            precinct_raw = precinct_match.group(1).replace("\n", ",").replace(",,", ",")
            precincts = [p.strip() for p in precinct_raw.split(",") if p.strip()]

        positions = [
            self._create_senator_position(),
            self._create_partylist_position()
        ]

        seen_positions = {"SENATOR", "PARTY LIST"}
        position_matches = list(re.finditer(r"([A-Z\u00D1 ,\-/]+) / Vote for (\d+)", text))

        for i, match in enumerate(position_matches):
            pos_name = match.group(1).strip()
            vote_for = int(match.group(2))

            if pos_name in seen_positions:
                continue
            seen_positions.add(pos_name)

            start_index = match.end()
            end_index = position_matches[i + 1].start() if i + 1 < len(position_matches) else len(text)
            section_text = text[start_index:end_index]

            candidates = self._extract_candidates_from_section(section_text)
            if candidates:
                position_entry = {
                    "position": f"{pos_name}",
                    "vote_for": vote_for,
                    "instructions": self.default_instructions,
                    "candidates": candidates
                }
                positions.append(position_entry)

        ballot_json = {
            "election_date": "MAY 12, 2025",
            "location": location,
            "clustered_precinct_id": clustered_precinct_id,
            "precincts_in_cluster": precincts,
            "positions": positions
        }

        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(ballot_json, f, indent=2, ensure_ascii=False)

    def _create_senator_position(self):
        """Returns the fixed senator position structure with instructions and candidates."""
        return {
            "position": "SENATOR",
            "vote_for": 12,
            "instructions": self.default_instructions,
            "candidates": self.senators
        }

    def _create_partylist_position(self):
        """Returns the fixed party list structure with bilingual instructions."""
        return {
            "position": "PARTY LIST",
            "vote_for": 1,
            "instructions": {
                "english": "For PARTY LIST CANDIDATES, CHECK THE BACK OF THIS BALLOT",
                "filipino": "Para sa mga kandidato ng Party List, tingnan ang likod ng balotang ito"
            },
            "candidates": self.partylist
        }

    def _extract_candidates_from_section(self, section_text):
        """
        Extracts a list of candidates from a given section of text.

        Handles multiple candidates and lone entries.

        Args:
            section_text (str): Text block to parse candidates from.

        Returns:
            List[Dict]: List of candidates with number, name, and party.
        """
        candidates = []
        pattern = re.compile(r"(\d{1,3})\.\s+([A-Z\u00D1.,' \-\n]+?)\s*\((.*?)\)", re.DOTALL)
        matches = list(pattern.finditer(section_text))

        if matches:
            for idx, match in enumerate(matches, start=1):
                number, name, party = match.groups()
                name = name.replace("\n", " ").strip()
                candidates.append({
                    "number": number,
                    "name": name,
                    "party": party.strip() if party.strip() else "IND"
                })
        else:
            single_match = re.search(r"1\.\s+([A-Z\u00D1.,' \-\n]+?)\s*\((.*?)\)", section_text)
            if single_match:
                name, party = single_match.groups()
                name = name.replace("\n", " ").strip()
                candidates.append({
                    "number": 1,
                    "name": name,
                    "party": party.strip() if party.strip() else "IND"
                })
        
        candidates.sort(key=lambda item:int(item["number"]))
        return candidates


class BatchProcessor:
    """
    Processes all ballot PDFs in a given directory and generates corresponding JSON outputs.

    Args:
        input_dir (str): Path to the folder containing ballot PDFs.
        output_dir (str): Path to output folder for resulting JSON files.
        senator_file (str): Path to senator reference JSON.
        partylist_file (str): Path to party list reference JSON.
    """
    def __init__(self, input_dir, output_dir, senator_file, partylist_file):
        self.input_dir = Path(input_dir)
        self.output_dir = Path(output_dir)
        self.processor = BallotProcessor(senator_file, partylist_file)

    def process_all(self):
        """Processes all PDF files in the input directory."""
        pdf_files = list(self.input_dir.glob("*.pdf"))
        for pdf_path in tqdm(pdf_files, desc="Processing ballots"):
            output_path = self.output_dir / (pdf_path.stem + ".json")
            self.processor.process_pdf(pdf_path, output_path)

# Main execution 
batch = BatchProcessor("input_pdfs", "output_jsons", "senator_candidates_full.json", "party_list_full.json")
batch.process_all()





