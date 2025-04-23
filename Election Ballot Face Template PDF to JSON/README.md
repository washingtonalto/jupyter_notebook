# Election Ballot Face Template PDF to JSON

This Python project automates the conversion of **Philippine election ballot PDFs** into a standardized, bilingual JSON format. It is built specifically for parsing official ballot templates published by the **Commission on Elections (COMELEC)** for the **May 2025 National and Local Elections**.

🔗 Official source of ballot templates:  
https://comelec.gov.ph/?r=2025NLE/2025BallotFace

📁 GitHub repository:  
https://github.com/washingtonalto/jupyter_notebook/tree/main/Election%20Ballot%20Face%20Template%20PDF%20to%20JSON

---

## 🔧 Features

- Converts COMELEC-issued PDFs into structured JSON.
- Extracts:
  - Election date
  - Location and precinct metadata
  - All positions with bilingual voting instructions
  - Complete candidate lists (Senator, Party List, Local)
- Supports lone candidates and multi-line candidate entries.
- Uses `pdfminer.six` with tuned layout parameters (`boxes_flow=None`) to ensure left-to-right, top-to-bottom reading order.

---

## 🗃️ Input Requirements

- PDFs must be ballot face templates directly from the official COMELEC website.
- All 66 **Senatorial** and 156 **Party List** candidates are assumed consistent across districts.
- Other positions (e.g., Mayor, Councilor) vary per city/district.

---

## 🚀 How to Use

1. Place all downloaded PDF templates in a folder named `input_pdfs`.
2. Ensure the following reference files are present:
   - `senator_candidates_full.json`
   - `party_list_full.json`
3. Run the parser:

```python
from election_ballot_parser import BatchProcessor

batch = BatchProcessor(
    input_dir="input_pdfs",
    output_dir="output_jsons",
    senator_file="senator_candidates_full.json",
    partylist_file="party_list_full.json"
)
batch.process_all()
```
The file [election_ballot_parser.ipynb](./election_ballot_parser.ipynb) is the Jupyter notebook file version while the [election_ballot_parser.py](./election_ballot_parser.py) is the Python script itself. If you're using Windows, you can just use run.bat which calls run_python.bat to call the *election_ballot_parser.py*.

4. All resulting `.json` files will be saved to the `output_jsons/` directory.

---

## 📦 Requirements

Install dependencies:

```bash
pip install pdfminer.six tqdm
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE.txt).

You are free to use, modify, and distribute this code as long as the original license and credit are preserved.

**Attribution**: Please cite **Washington Alto** in any derivative work, publication, or shared implementation based on this project.

---

## 🙌 Credits

Created and maintained by **Washington Alto** to help fellow Filipino voters and developers working with election data.



---

## 🤖 Generative AI Acknowledgment

This project was developed with the assistance of **ChatGPT-4o**, which was used to collaboratively create, refine, and debug the code.

The object-oriented structure and reusable Python class design were specifically requested by the author to ensure clarity, maintainability, and extensibility.

While the final implementation was tested and adjusted manually, portions of the code and structure were generated using generative AI tools.
