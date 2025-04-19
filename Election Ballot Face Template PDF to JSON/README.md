
# Election Ballot Parser

This project provides reusable Python classes to parse Philippine election ballot PDFs into a standardized JSON format.

## Features

- Strict parsing from actual ballot PDFs (no hallucinations).
- Object-oriented structure.
- Supports batch processing: entire folder of PDFs to a folder of JSON outputs.
- Reuses reference files for Senator and Party List candidates for validation.
- Bilingual instruction preservation (English and Filipino).

## Requirements

Install required modules:

```bash
pip install pdfminer.six tqdm
```

## Usage

1. Prepare your input folder (e.g., `input_pdfs/`) containing all ballot PDFs.
2. Make sure your `senator_candidates_full.json` and `party_list_full.json` are available.
3. Use the following code:

```python
from election_ballot_parser import BatchProcessor

batch = BatchProcessor(
    "input_pdfs",      # Folder containing PDF ballots
    "output_jsons",    # Output folder for JSON files
    "senator_candidates_full.json",  # Reference senator list
    "party_list_full.json"            # Reference party list
)
batch.process_all()
```

Output JSON files will be saved inside the `output_jsons/` folder.

## Files

- `election_ballot_parser.py`: Main Python code.
- `senator_candidates_full.json`: Reference senator list.
- `party_list_full.json`: Reference party list.
- `README.md`: This guide.

---
