# Training and verification notebook

`train_and_verify.ipynb` contains the workflow used to (a) train the FFNN
controller that approximates the stabilizing PID controller and export its
weights to CSV, and (b) compute CROWN and IBP output bounds via
[`auto_LiRPA`](https://github.com/Verified-Intelligence/auto_LiRPA) for the
comparison in **Fig. 6a**.

## Status

The notebook is **exploratory**: it is organized around walkthroughs of several
NN-verification libraries (`jax_verify`, `auto_LiRPA`) and contains commented /
alternative cells, so it is not a one-click pipeline. Because the trained
weights are already provided in [`../weights/`](../weights), running it is
**optional** — you only need it to retrain the controller or to regenerate the
CROWN/IBP curves.

## Dependencies

- `torch`, `numpy`, `pandas`, `matplotlib`
- `auto_LiRPA` (clone from the link above) for the CROWN/IBP cells

## Inputs / outputs

- Training data: the closed-loop PID input/output samples in
  [`../data/pid_y.csv`](../data/pid_y.csv) and
  [`../data/pid_u.csv`](../data/pid_u.csv).
- Output: weight matrices `W1, W2, W3` (already exported to `../weights/`).
