
%% Preparation for all figures

% CHANGE THESE VARIABLES BASED ON YOUR DOWNLOAD FOLDERS:

data_dir = '../data'
common_dir = '../HE-model-analysis-matlab'
addpath(common_dir)

% ****************************************

% common include
common

% load targets
load([ data_dir filesep 'targets_synscale_20rand_6inputs_pairs_MPP.mat' ])

% with rel stds
load([ data_dir filesep 'targets_6inputs_pairs_MPP_relsyns.mat' ])
load([ data_dir filesep 'targets_6inputs_pairs_MPP_relsyns_std.mat' ])
syns_labels = {
  'synS_HE8_HN3_rel',
  'synS_HE8_HN4_rel',
  'synS_HE8_HN6_rel',
  'synS_HE8_HN7_rel',
  'synS_HE12_HN3_rel',
  'synS_HE12_HN4_rel',
  'synS_HE12_HN6_rel',
  'synS_HE12_HN7_rel'};

%% Plotting spike-triggered average synaptic response shape and its variance

% Time resolution of STA data
dt = 9.9e-5;

sta_shape_plot = @(time_array, avg_array, std_array)...
    plot_superpose({...
      plot_abstract({[time_array; time_array(end:-1:1)], ...
                    [avg_array + std_array; avg_array(end:-1:1) - std_array(end:-1:1)], ...
                    [.7 .7 .7]}, ...
                    {'time [s]', 'current [nA]'}, ...
                    sprintf('Spike-triggered average\nof synaptic currents'), ...
                    {'SD'}, 'patch', struct('plotProps', struct('EdgeColor', 'none'))), ...
      plot_abstract({time_array, avg_array, 'k'}, ...
                    {'time [s]', 'current [nA]'}, ...
                    'Spike-triggered synaptic currents', ...
                    {'mean'}, 'plot', ...
                    struct('plotProps', struct('LineWidth', 2)))}, ...
                   {}, '', ...
                   struct('tightLimits', 1, 'fixedSize', [2.5 3]))

run([ common_dir filesep '5_27B-Oct16/HN03_HE08_avg_std.m' ])
scale = ...
    get(target_HE8_12_syns_rel_std_db(find(target_HE8_12_syns_rel_db(:, ...
                                                  'inputdir') == 6), ...
                                      'synS_HE8_HN3_rel', 1), 'data') ./ amplL;
% can't find sta_shape_plot, so replace with plot for now
hn3_he8_5_27b_plot = sta_shape_plot((1:size(avg_array, 1))'*dt, ...
                                    avg_array * scale, std_array * scale);

run([ common_dir filesep '5_27B-Oct16/HN07_HE08_avg_std.m' ])
scale = ...
    get(target_HE8_12_syns_rel_std_db(find(target_HE8_12_syns_rel_db(:, ...
                                                  'inputdir') == 6), ...
                                  'synS_HE8_HN7_rel', 1), 'data') ./ amplL;
hn7_he8_5_27b_plot = sta_shape_plot((1:size(avg_array, 1))'*dt, ...
                                    avg_array * scale, std_array * scale);

plotFigure(plot_stack({hn3_he8_5_27b_plot, hn7_he8_5_27b_plot}, ...
                      [Inf Inf Inf Inf], 'x', ['HN3 vs HN7 to HE8 STA ' ...
                    'shape average and variation'], ...
                      struct('yLabelsPos', 'left', 'yTicksPos', 'left', ...
                             'noTitle', 1, 'fixedSize', [4 3])));

%% Relative synaptic strength bar plots showing all inputs for HE8 and HE12

% HE8/12; input 6 temp values
he_num = 8; % pick which one to plot
pages_stats_db = stats_db;
for input_num=1:6
  input_db = ...
      swapRowsPages(target_HE8_12_syns_rel_std_db(find(target_HE8_12_syns_rel_db(:, ...
                                                    'inputdir') == input_num), ...
                                                  :, :));
  combined_stats_db = ...
      stats_db(input_db(:, syns_labels), {}, {'mean', 'STD'});
  pages_stats_db = ...
      addColumns(pages_stats_db, ...
                 renameColumns(...
                   swapColsPages(renameColumns(combined_stats_db(:, [ '/HE' num2str(he_num) ...
                      '/' ], 1), ...
                                               [ '/synS_HE' num2str(he_num) '_HN(\d)_rel/' ], ...
                                               'HN$1')), ...
                   1, ['i' input_names{input_num} ]));
end

plotFigure(plot_bars(pages_stats_db, ...
                     [ 'HE(' num2str(he_num) ') relative synaptic strength and variation' ], ...
                     struct('fixedSize', [4 3], 'noTitle', 1, ...
                            'axisLimits', [.5 4.5 0 .81], ...
                            'quiet', 1, ...
                            'yLabelsPos', 'left', 'yTicksPos', 'left', ...
                            'barAxisProps', ...
                            struct('plotProps', ...
                                   struct('EdgeColor', 'none', 'FaceColor', 'k')), ...
                            'axisProps', ...
                            struct('Box', 'off'))))

% manual correction

% select leftmost axis and do:
ylabel([ 'HE(' num2str(he_num) ') relative synaptic strength' ]);

% for each selected axis do, first one:
set(gca, 'XTickLabel', {'HN3', '4', '6', '7'})
% the rest:
set(gca, 'XTickLabel', {'3', '4', '6', '7'})

%% 5/22B relative synaptic strengths versus top models

% load and plot table
[m_bundle_8syn_input4_b29 a_ranked_8syn_input4_b29 ] = ...
    pace_runsearch_inputdir_8syns_reltarget_std(4,47,29,5,256,5000);

% < 1 std for everything
joined_ranked_db = ...
    joinOriginal(a_ranked_8syn_input4_b29, ':', ...
                 struct('origCols', {{'/ItemIndex/', '/phase_median/'}}, ...
                        'rankedCols', 'Max'));
% 5120 models

top_joined_db = ...
    joined_ranked_db(joined_ranked_db(:, 'Max') <= 1, :);
dbsize(top_joined_db)
% => only 1 top model?

% read rel syn weights mean/STD
input_num = 4;
input4_target_HE8_12_syns_rel_std_swap_db = ...
    swapRowsPages(target_HE8_12_syns_rel_std_db(find(target_HE8_12_syns_rel_db(:, ...
                                                  'inputdir') == input_num), ...
                                                :, :));

% plot using bars so bars don't go into negative
combined_stats_db = ...
    stats_db(input4_target_HE8_12_syns_rel_std_swap_db(:, syns_labels), ...
             {}, {'mean', 'STD'});
top_stats_db = statsMeanStd(top_joined_db(:, syns_labels));

% don't take N values
combined_stats_db.data(:, :, 2) = top_stats_db.data(1:2, :);

plotFigure(plot_bars(combined_stats_db, ...
                     '5/22B measured vs 5 models', ...
                     struct('fixedSize', [4 2], 'noTitle', 1, ...
                            'axisLimits', [.5 2.5 0 0.6], ...
                            'yLabelsPos', 'left', 'yTicksPos', 'left', ...
                            'axisProps', ...
                            struct('Box', 'off'))))


%% 5/20B relative synaptic strengths versus top models

% load it
[m_bundle_8syn_input3_b30 a_ranked_8syn_input3_b30 ] = ...
    pace_runsearch_inputdir_8syns_reltarget_std(3,47,30,10,256,10000);

plotFigure(plotUITable(a_ranked_8syn_input3_b30(1:20, :), ...
                       'input #3 8syns top 20', ...
                       struct('fixedSize', [12 8])))
% => all good

% < 1 std for everything
joined_ranked_input3_db = ...
    joinOriginal(a_ranked_8syn_input3_b30, ':', ...
                 struct('origCols', {{'/ItemIndex/', '/phase_median/'}}, ...
                        'rankedCols', 'Max'));
top_joined_input3_db = ...
    joined_ranked_input3_db(joined_ranked_input3_db(:, 'Max') <= 1, :);
dbsize(top_joined_input3_db)
% => 4704 models, so going up to 10,000 evals was overkill

% Show synapses with bar plot
combined_stats_db = ...
    stats_db(input3_target_HE8_12_syns_rel_std_swap_db(:, syns_labels), ...
             {}, {'mean', 'STD'});
top_stats_db = statsMeanStd(top_joined_input3_db(:, syns_labels));

% don't take N values
combined_stats_db.data(:, :, 2) = top_stats_db.data(1:2, :);

plotFigure(plot_bars(combined_stats_db, ...
                     '5/20B measured vs all <1 STD models (4704)', ...
                     struct('fixedSize', [4 2], 'noTitle', 1, ...
                            'axisLimits', [.5 2.5 0 0.82], ...
                            'yLabelsPos', 'left', 'yTicksPos', 'left', ...
                            'axisProps', ...
                            struct('Box', 'off'))))
