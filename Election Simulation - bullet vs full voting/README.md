# Election Simulation: Bullet Voting vs Full Voting (2025 Philippine Senate)

This project simulates a senatorial election based on the upcoming 2025 Philippine national elections. It models how **bullet voting** compares with **full voting** behavior in a realistic 12-vote maximum ballot system used for the Senate.

## 📊 What It Simulates

- 66 candidates (`c1` to `c66`)
- 100 simulated voters
- Each voter can vote for up to **12 candidates**
- Some voters can choose to vote only for **favored candidates** (a.k.a. *bullet voting*)

## 🧪 Voting Scenarios

1. **Full Voting**  
   Every voter shades exactly 12 candidates randomly.

2. **Bullet Voting**  
   25% of voters vote only for a select few *favored candidates*, possibly fewer than 12.  
   The rest vote like in the full voting scenario.

## 🎯 Objectives

- Visualize the impact of bullet voting on election outcomes.
- Highlight how favored candidates can gain an advantage.
- Compare both scenarios via animated bar charts and a static comparison plot.
- Export final tallies and ballot-level logs for audit and verification.

## 📁 Project Contents

| File | Description |
|------|-------------|
| [`Election simulation - bullet vs full voting.ipynb`](./Election%20simulation%20-%20bullet%20vs%20full%20voting.ipynb) | Fully documented Python script in Jupyter Notebook to run the simulation |
| [`election_full_voting.gif`](./election_full_voting.gif) | Animated bar chart for full voting |
| [`election_bullet_voting.gif`](./election_bullet_voting.gif) | Animated bar chart for bullet voting |
| [`election_full_voting.mp4`](./election_full_voting.mp4) | Video of animated bar chart for full voting |
| [`election_bullet_voting.mp4`](./election_bullet_voting.mp4) | Video of animated bar chart for bullet voting |
| [`comparison_top12_bar_chart.png`](./comparison_top12_bar_chart.png) | Static comparison of top 12 candidates |
| [`election_result_full_voting.csv`](./election_result_full_voting.csv) | Final vote tally for full voting |
| [`election_result_bullet_voting.csv`](./election_result_bullet_voting.csv) | Final vote tally for bullet voting |
| [`election_votes_log_full_voting.csv`](./election_votes_log_full_voting.csv) | Detailed ballot votes (full) |
| [`election_votes_log_bullet_voting.csv`](./election_votes_log_bullet_voting.csv) | Detailed ballot votes (bullet) |

## 🧠 Favored Candidates

To simulate campaign-driven support or bloc voting, the following candidates were designated as favored:

```
c51, c45, c5
```

These are visually highlighted in red in both the animated bar chart and leaderboard.

## 🖥️ How to Run

### 1. Install dependencies

```bash
pip install matplotlib pandas
```
- Install ffmpeg (see link [https://ffmpeg.org/download.html](https://ffmpeg.org/download.html))

### 2. Run the script

```bash
python "Election simulation - bullet vs full voting.py"
```

### 3. Outputs generated

- Animated `.gif` files for both scenarios
- `.csv` logs for verification
- Bar chart comparison as `.png`

## 📈 Sample Insights

- Bullet voting allows focused support, giving favored candidates a higher chance to rank in the Top 12.
- Even with fewer total votes, bullet-voted candidates can outperform broadly voted ones due to vote dilution.

## 🙌 Credits

Created and maintained by **Washington Alto** to help fellow Filipino voters.

## 🤖 Generative AI Acknowledgment

This project was developed with the assistance of **ChatGPT-4o**, which was used to collaboratively create, refine, and debug the code.

The object-oriented structure and reusable Python class design were specifically requested by the author to ensure clarity, maintainability, and extensibility.

While the final implementation was tested and adjusted manually, portions of the code and structure were generated using generative AI tools.

## 📜 License

This project is released under the MIT License. You are free to modify, distribute, or adapt this for educational or research purposes.

---

> Made with ❤️ for civic awareness and data-driven thinking.  
> Simulate. Visualize. Decide smarter.