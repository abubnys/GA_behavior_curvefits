# Curve fitting of circadian Generalized Arousal assay
We used an automated Generalized Arousal assay (Arrieta-Cruz et al 2007) to continuously record the total motor activity of singly housed mice for 4 to 6 weeks. This package parses the raw behavioral data from an excel file into a matlab structure organized by cage, week, and day. Then, for each cage it spline smooths the data, finds the behavioral transitions from sleeping to waking and from waking to sleeping and fits these transitions to a 3 parameter logistic curve. 

### Running the package
`GA_total_parser` takes the raw data from `raw_data.xlsx`, which is from a 3 week long experiment with 4 cages, and parses it into the structure `parsed_data.mat`. This script also calls the function `GA_parser_by_day`. To run `GA_total_parser`, specify the location of the excel file containing raw experimental data in `fpath` and the name of said file in `fnom`, then run the script and save the output `mouse_activity`.

The script `run_curve_fitting` takes the structure `mouse_activity` generated by `GA_total_parser` (saved in the file `parsed_data`), finds the behavioral transitions for each cage in the experiment, and fits each of these transitions to the 3 parameter logistic equation, saving the best fits, organized by cage, in the structure `curve_fits`. This script calls the functions `wake_times_function`, `window_picker`, and `log_fit`.

The function `wake_times_function` takes the full data set for a single cage and finds the behavioral transitions bounding low activity and high activity periods:

![wake times](/readme_screenshots/wake_times.png)

The function `window_picker` takes the transition points identified by `wake_times_function` and identifies the window over which to fit the data to a logistic curve. If `LD = 1`, the function finds the sleep-wake transitions and sets the window as the last local minimum before the transition to the first local maximum after the transition. If `LD = 2`, the function finds the wake-sleep transitions and sets the window as the last local maximum before the transition to the first local minimum after the transition. It then feeds these intervals in the data into the function `log_fit` for curve fitting.

The function `log_fit` takes the behavioral transition curve and fits it to a logistic equation.

