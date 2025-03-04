---
jupytext:
  formats: ipynb,md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.14.5
kernelspec:
  display_name: Python 3 (ipykernel)
  language: python
  name: python3
---

+++ {"tags": ["remove-cell"]}

24/07/23

- Added as placeholder for case-study summary and conclusions, pending final numerics and analysis.

30/07/23

- Added some discussion.
- NEEDS NUMERICAL DETAILS added (number of data points, parameters etc.)
   - Added as a table, note some options here in Myst, https://mystmd.org/guide/tables, although only simple case renders in raw notebook (but can't link to it?). Could use Tex for more control.
- Conclusions a bit short, may also want to push to separate chpt?
- Note glue() figure over docs not working currently (see https://jupyterbook.org/en/stable/explain/migration.html?highlight=glue%20figures#limitations-for-figures-and-math), so just reference them here.

+++

(chpt:case-study-summaries)=
# Case studies: summaries, conclusions and outlook

In the preceding chapters, three case studies were demonstrated. As already noted elsewhere ({numref}`Chpt. %s <chpt:extracting-matrix-elements-overview>`), the $N_2$ case has already been demonstrated to be successful for a range of energies and ionization channels (orbitals), see Refs. {cite}`marceau2017MolecularFrameReconstruction,hockett2023TopicalReviewExtracting` for further details. However, it is included here as a benchmark case, useful for testing the methodology, computational routines and limitations and so forth. In particular, it represents a case of a reasonable level of complexity for method development, without an excessive number of {{ RADMATE }}/fitting parameters to deal with.

The other two case studies ({numref}`Chpt. %s <chpt:ocs-case-study>` & {numref}`Chpt. %s <chpt:c2h4-case-study>`) are presented in a more experimental/preliminary capacity. In both cases, a much larger number of {{ RADMATE }} are required, and a higher-information content dataset with 3D alignment (as tested) and/or multiple polarization geometries, is expected to be required for a high-fidelity {{ BOOTSTRAP }} to be successful. In the current cases as presented, some progress towards this has been achieved, although further work remains to improve on the current results. Nonetheless, as stated previously, these new results are interesting and present a stepping-stone for studies on {{ RADMATE }} retrieval in complex systems, and a launching point for similar studies.

+++

## General notes on fitting methodologies for the case studies

As discussed elsewhere, the general {{ BOOTSTRAP }} is quite flexible. In the case studies, much of this flexibility is yet to be explored! This is, primarily, a question of the time and effort available: for the $N_2$ case obtaining a set of 1000 fit results takes approximately 2 hours on a workstation.[^benchmarksFootnote] However, scaling up to more complex cases is significantly more costly, with $OCS$ and $C_2H_4$ results requiring approximately 1-2 orders of magnitude more computational time - on the order of days per few hundred fits. Work towards speeding up fitting, e.g. using GPU-based routines and/or lower-level code for speed, is ongoing. Deployment to high-performance computing (HPC) resources, e.g. clusters, is also ongoing. The results herein, therefore, represent only the preliminary stages of testing and tuning the {{ BOOTSTRAP }} for these more complex cases, but already appear quite promising.

+++

In each case, as detailed in {numref}`Chpt. %s <sect:basis-sets:fitting-intro>` & {numref}`Chpt. %s <sect:basic-fit-setup>`, the fitting basis sets were created based on *ab initio* results, with all {{ RADMATE }} greater than a threshold value of 0.01 used for both simulated data generation and fitting, and automatic parameter constraints applied to reduce the effective number of "free" or "floated" terms in the fitting. Fitting was only tested for single energy-points. The overall size of the problems as run in this manner were:

+++ {"tags": ["remove-cell"]}

- $N_2$ ($D_{\infty h}$)
    - 6 complex matrix elements, giving 12 real fitting parameters (magnitude and phases).
    - Automatic symmetry constraints resulted in 4 magnitudes and 3 phases floated.
    - 13 t-points over the {{ RWP }} 1/2 revival feature were selected, to match the example case in Refs. {cite}`marceau2017MolecularFrameReconstruction,hockett2023TopicalReviewExtracting`.

- $OCS$ ($C_{\infty v}$)  
Set 22 complex matrix elements to 44 fitting params
51 t-points over 1/2 and 1/4 revival (note discontinuous)
Full (auto) symmetry constraints
Basis set size = 44 params. Fitting with 15 magnitudes and 14 phases floated.

C2H4
Set 38 complex matrix elements to 76 fitting params
73 t-points, note in grid units
Partial (auto) symmetry constraints
Basis set size = 76 params. Fitting with 14 magnitudes and 25 phases floated.

+++

| System   | Symmetry    | Energy (eV) | Complex matrix elements | Fitting params | Floated params (magnitude, phase) | $t$-points |
| :--- | ---: | ---: | ---: | ---: | ---: |  ---: |
| $N_2$    | $D_{\infty h}$ | 1  | 6 | 12 | 4,3 | 13 |
| $OCS$    | $C_{\infty v}$ | 10  | 22 | 44 | 15,14 | 51 |
| $C_2H_4$    | $C_{2h}$  |  6   | 38 | 76 | 14,25 | 73 |

+++

In both of the more complex cases, the computational testing involved starting with the protocol as used for the $N_2$ reference case, then adding data points until clustering was observed in the $\chi^2$ histograms, indicating that multiple minima were successfully located. This is a necessary first step in testing, and signifies that the methodology is working as expected; however, this is not sufficient to guarantee that the information content of the dataset was adequate for complete {{ RADMATE }} retrieval, nor to guarantee a high-fidelity retrieval (herein "complete" is used to indicate that a unique set of fit parameters may be found, whilst the "fidelity" is the more stringent test of the veracity of these parameters). In fitting, automatic parameter relations were set, which fixed equivalent parameters (see {numref}`Chpt. %s <sect:basis-sets:fitting-intro>` & {numref}`Chpt %s <sect:basic-fit-setup>` for details). For $N_2$ and $OCS$ no additional constraints were imposed; for $C_2H_4$ some additional magnitude-only constraints were set for parameters with identical magnitudes which were not set by the automated routine, although corresponding phase relations were *not* set (see tabulations in {numref}`Chpt. %s <chpt:ocs-case-study>` for full details) - this case is therefore an interesting test of whether the correlated phase relations will be correctly recovered by the {{ BOOTSTRAP }}. It is, however, anticipated that for high-fidelity retrieval, additional constraints may be required on a case-by-case basis, and particularly for large problems, e.g. by fixing additional symmetry relations, making use of additional data and so forth - this is discussed further below. 

In each case, the lowest $\chi^2$ cluster was assumed to be the "best" result, i.e. the true set of {{ RADMATE }}, and further tested for spread and veracity, as compared with the known inputs. This is an easy methodology to implement computationally although, in general, one may wish to inspect several sets of candidate fit parameters in cases with noise and/or large solution spaces, since the lowest $\chi^2$ may not, in fact, be the best, and a true global minima may not exist. Similarly, the presence of multiple equivalent minima is possible in cases where some quantities are undefined, which may lead to issues with phase retrieval in particular (see {{ QM12 }} for further discussion) - with the current codebase this can be probed by changing the binning of candidate fit results, and examining the spread of parameters for a given choice of binning, as outlined in the case studies. (In the case studies, the retrieved matrix elements are taken as an average over the best cluster of fits, hence large spread in a given parameter for the chosen cluster indicates a case where the given parameter is not well defined - this is likely to appear as a clear deficiency in the corresponding density matrix and/or {{ MF }}-{{ PADs }} when assessing the fidelity of the retrieval.) The likelihood of a good fit result will also depend on the number of data-points used in fitting, as well as the underlying alignment and molecular symmetry properties - generally the form of the {{ GAMMACHANNEL }} as discussed in {numref}`Sect. %s <sec:tensor-formulation>` - which have not been carefully investigated in these cases as yet.

For the $N_2$ case, the {{ RWP }} is as detailed in Refs. {cite}`marceau2017MolecularFrameReconstruction,hockett2023TopicalReviewExtracting`, which made use of a two-pulse alignment scheme. Data-points over the {{ RWP }} half-revival feature were chosen initially to approximately match the previously published cases (13 $t$-points in the current case, vs. 11 in the original study, although that study also made use of larger datasets up to 89 $t$-points for higher-fidelity {{ BOOTSTRAP }}, see Ref. {cite}`marceau2017MolecularFrameReconstruction` supplementary materials for further details).

For the $OCS$ case, the {{ RWP }} is as per obtained in recent ultrafast experiments {cite}`woodhose2022OCSExperimentalWork`, which made use of a single-pulse alignment scheme to prepare a 1D molecular alignment (no orientation). For testing purposes, an (arbitrary) number of low-order terms $Q\neq0$ and $S\neq0$ were added for the work herein (with a linear ramp in $t$), including $K=1$ terms for orientation (see figures in {numref}`Chpt. %s <chpt:ocs-case-study>` for full details). Although these are not expected to be physically realistic, they will be indicative of the terms present in a true 3D alignment case. Note that the temporal data used in this case is discontinuous, with $t$-points over both the 1/4 and 1/2 {{ RWP }} revival features selected.

For the $C_2H_4$ case, the {{ RWP }} is a realistic case, as used in Ref. {cite}`gregory2021MolecularFramePhotoelectron`, which includes $S\neq0$ terms and even-$K$ even-$S$ terms (see figures in {numref}`Chpt. %s <chpt:c2h4-case-study>` for full details). Interestingly, this case was sufficient for retrieval of {{ MF }}-{{ PADs }} using the matrix-inversion method, so is expected to be successful with the {{ BOOTSTRAP }} provided enough data-points are incorporated and the fitting is well-constrained. Note that the temporal axis in this case is in arbitrary units.

[^benchmarksFootnote]: Running on 20 (logical) cores of an AMD Threadripper 2950X based workstation, this required 5 GB of RAM and took on the order of 2 hours, although note that the time per fit cycle had large variance, since convergence time depends on the start parameters. Further benchmarks for the current codebase can be found in the {{ PEMtk_docs }}.

+++ {"jp-MarkdownHeadingCollapsed": true}

## Retrieval fidelity

The continuum density matrices provide a way to quickly assess the {{ BOOTSTRAP }} fidelity in these test cases, without the necessity of consulting rather complex tabulations of {{ RADMATE }}/fitting parameters and the associated statistics. In general, it is expected that the *differences* between the true and reconstructed density matrices will be on the order of the experimental noise in a high-fidelity case. For each case study, such a comparison is given - see {numref}`fig-N2-densityComp` ($N_2$ case), {numref}`fig-OCS-densityComp` ($OCS$ case), and {numref}`fig-C2H4-densityComp` ($C_2H_4$ case) (see {{ book_HTML }} for interactive plots). Note that in the comparisons herein the sign of the phases is assumed to be undefined, so phases are remapped to positive values only (i.e. assumed to be in the $0:\pi$ range). Depending on the symmetry of the problem (hence the form of the {{ GAMMACHANNEL }}), this may or may not be the case in practice - in particular cases with multiple polarisation geometries and/or 3D alignment may break this assumption.

For $N_2$, the recovered and reference density matrices are in good agreement, and differences in both the real and imaginary components are on the order of the noise-floor in the simulated dataset ($\approx\pm10\%$). This indicates a high-fidelity retrieval from only a small number of data-points (13 in the example case), and also indicates that improvements may be found here by incorporating additional data into the fitting procedure.

For $OCS$ ({numref}`fig-OCS-densityComp`) and $C_2H_4$ ({numref}`fig-C2H4-densityComp`) cases, a number of general comments may be made. Firstly, the overall patterns of values observed in the reconstructed density matrices are in good agreement with the reference cases, however the agreement in the absolute values (hence fidelity) are quite variable. For $OCS$ differences as large as 0.4 are observed, whilst for $C_2H_4$ differences as large as 1 are observed. Secondly, some patterns are inverted in the retrieved cases, indicating issues with the signs of the retrieved quantities. This is likely indicative of missing phase relations in the data (i.e. the {{ GAMMACHANNEL }} restrict the accessible terms), or indicates that multiple minima exist in the $\chi^2$ hypersurface with differences in the phases. Thirdly, the retrieved {{ RADMATE }} tend to have, in general, larger values in both real and imaginary components for the higher-order terms (larger $l$) than the reference values: this can be seen in the fading (vignetting) of the colourmaps to higher-order in the reference cases, which is not present in the retrieved maps.

In general, these issues all suggest that the {{ BOOTSTRAP }} is partially working for these cases, but may not yet be complete. A number of avenues remain to be explored here, in particular: 

- The analysis of other candidate parameter sets to check for uniqueness/equivalence. 
   - This may required deeper analysis of the existing results with finer $\chi^2$ binning than the current cases, which indicate significant spreading in some parameters (see the *Raw results* and *Phases* subsections in each case study chapter, particularly the paramter plots which indicate the spread in results).
   - This analysis is not yet automated, but this may be possible by setting preferences on spreading of results to determine optimum grouping of results.
- Further boostrapping with larger datasets and/or using the existing best fit parameters as seed values to further probe the local $\chi^2$ surface.
- Fitting with reduced parameter sets. These were set based on the reference matrix elements with a threshold for inclusion of 0.01 (see {numref}`Chpt. %s <sect:basic-fit-setup>`), but raising this to 0.1 would remove many of the higher-order terms from the fitting, which may result in higher-fidelity retrieval of the lower-order terms which then remain.
- Fitting with more constraints, e.g. 
   - Setting lower limits on higher-order terms. Although, in practice, this may not be known _a priori_ for a given case, as a general rule-of-thumb it should be applicable (as indicated by the _ab initio_ results for the cases herein).
   - Enforcing orthogonality on different continua, as per the symmetrized harmonics defining each case. For the $C_2H_4$ case in particular, this would add additional phase restrictions which were missing in the current study.
- Further testing with simulated data with both more and less noise present to evaluate the effect of the noise-floor in different cases.
- Finally, it is of note (and also noted elsewhere) that there may still be bugs or numerical issues with the preliminary results presented herein, since they represent the first trials of the {{ PEMtk_repo }} and {{ BOOTSTRAP }} for complex cases. However, given that the same routines are used to generate the simulated data, any issues should, at least, be self-consistent for these test cases. Eagle-eyed readers may notice that in the $C_2H_4$ test case, the $\beta_{0,0}(t)$ parameters are negative, which is unphysical; this indicates a phase error in the calculation and has since been fixed, but does *not* affect the fitting protocol thanks to the self-consistent nature of the numerics.



% Figures will be at, e.g., {numref}`fig-N2-densityComp` ONCE CASE STUDY NOTEBOOKS UPDATED.

+++

## MF-PAD retrieval

The {{ MF }}-{{ PADs }} also provide an interesting observable to test from the retrieved {{ RADMATE }} - they provide less detail than the density matrices, but do give a better indication of the sensitivity of the observables to the retrieved parameters (via the {{ GAMMACHANNEL }}) in a given case. For example, some phase relations may not be important for {{ MF }} retrieval, or only appear under certain polarization geometries. For both the $N_2$ and $C_2H_4$ cases the work in Ref. {cite}`gregory2021MolecularFramePhotoelectron` provides an interesting perspective here, since it outlines a direct {{ MF }} reconstruction method which bypasses the difficulty of phase-retrieval and fitting via a matrix-inversion protocol. This is found to work well for both these cases, although in a similar manner to a fitting approach will be fundamentally limited in any given case by the symmetry of the problem.

For the case studies, the reconstructed {{ MF }}-{{ PADs }} are somewhat variable, as may be expected from the preceding discussion on fidelity. For $N_2$ ({numref}`fig-N2-compC` - {numref}`fig-N2-diff`), the results are excellent - as expected from the previous studies in this case. In particular, the good agreement for the diagonally-polarized case indicates that the relative phase *between* the two continua is defined in this type of data, and successfully retrieved. The normalised difference plots in {numref}`fig-N2-diff` indicate that the main differences between the retrieved and reference cases can be observed in some of the smaller lobes, indicating that the fidelity is high, but not perfect. As discussed in the previous section, adding data and analysing the effect of noise on the {{ BOOTSTRAP }} may improve on the retrieval fidelity, and this was previously explored for $N_2$ in Ref. {cite}`marceau2017MolecularFrameReconstruction`.

For the more complex cases, the fidelity is lower, and the results generally suggest that, although the dominant continuum is fairly well recovered, the loss of phase information and/or generally lower information content of the data is an issue. For $OCS$ ({numref}`fig-OCS-compC` - {numref}`fig-OCS-diff`), the $(x,y)$ {{ MF }}-{{ PADs }} are close to the reference case, although the lobes are significantly sharper. The $z$ case, however, is very different, with the main lobe in the $-z$ direction, as opposed to $+z$ in the reference case. This indicates that the terms related to breaking up-down symmetry are not well reproduced in this case, and is most likely an issue with the associated phases; as noted above this may be due to issues with the analysis and binning of the fit results, or a more fundamental limitation due to the dataset and/or symmetry of the problem - potentially with the choice of additional terms added to the {{ ADMs }} - and more work is required here to ascertain this.

For $C_2H_4$ ({numref}`fig-C2H4-compC` - {numref}`fig-C2H4-diff`), the opposite is true: the $z$ case is fairly well reproduced, although rotated, whilst the $(x,y)$ cases are in poor agreement with the reference results. Again it is the dominant continuum which is best reproduced; however, in this case the discrepancies in all polarization geometries appear as additional symmetry breaking, which would not be present in the correctly symmetrized (orthogonal continua) case - as seen in the reference results ({numref}`fig-C2H4-ref`). This indicates that the respective continua are not well-separated in the recovered {{ RADMATE }}, i.e. the phase relations are such that additional symmetry breaking is seen. As for the $OCS$ case, this may be due to averaging over multiple minima in the fitting phase space, and/or may relate to a lack of information in the test dataset. In this case, given the results of Ref. {cite}`gregory2021MolecularFramePhotoelectron`, it is anticipated that the dataset is sufficient, and that most issues arise from the complexity of the $\chi^2$ hypersurface and the configuration of the {{ BOOTSTRAP }}, and/or post-processing of the results. As discussed above, in the current test case some phase relationships between parameters were not constrained, and this is likely the main source of the discrepancy; ideally the fitting should recover these relations in general, but this will, again, depend on the form of the {{ GAMMACHANNEL }} and the dataset used, which will ultimately determine which phase relations are defined and therefore recoverable. Probing this behaviour in general, and in this case, in more depth is currently underway. One way to probe this type of issue further is to define specific orthogonality relations in the fitting procedure via symmetrized matrix elements. This would provide a means to enforce the distinction between the continua without the necessity of *ab initio* {{ RADMATE }} (this is possible with the current codebase, but has not been explored for this case as yet). This would also be consistent with the success of the approach in  Ref. {cite}`gregory2021MolecularFramePhotoelectron`, since symmetry is rigorously enforced in the mathematics of the matrix-inversion method.

In all cases, the "diagonal" polarization case is another good test of the phase relations, since this is also sensitive to the phase relations between the $z$ and $(x,y)$ continua. For $N_2$ the good agreement of the results with the reference case is, again, indicative of the generally good fidelity of the reconstruction in this case. Similarly, the differences in the more complex $OCS$ and $C_2H_4$ cases are consistent with the previous discussion: the main difference between these cases is the additional symmetry breaking in the lower-symmetry $C_2H_4$ case, leading to the appearance of an overall rotation and additional lobes, particularly directed out of the $(x,z)$ plane, relative to the reference case. Again, this is indicative of continua mixing, arising from incorrect/undefined/low-fidelity phase terms.

% Interestingly, the OCS case looks OK for the (x,y) MFPADs, but poor for (z), and the opposite for C2H4... my guess is this is either to do with the symmetry relative to the wavepacket, and/or the reconstruction is dominated by the larger continuum components, but I don't really have the time or inclination to get further into the channels functions right now!


% Figures will be at, e.g., {numref}`fig-N2-densityComp` ONCE CASE STUDY NOTEBOOKS UPDATED.
% MFPADS:
% fig-N2-compC
% fig-N2-ref
% fig-N2-diff

+++

% May want to move to separate chapter?

## Conclusions and outlook

Overall, the case studies provide interesting material for a number of reasons. First and foremost, they indicate that the {{ BOOTSTRAP }} method is applicable to larger problems (38 {{ RADMATE }} in the largest case), at least in principle. Secondly, they indicate the issues in these cases, which still remain exceedingly complicated retrieval problems, despite the generality and automation of the {{ BOOTSTRAP }} implemented in the {{ PEMtk_repo }}. In these specific cases the route to complete and/or higher-fidelity {{ BOOTSTRAP }} is clear, but significant efforts are still required to conclusive demonstrate this, and develop more efficient and effective fitting strategies for large solution hyperspaces. Nonetheless, this is an interesting and notable step towards a general method for these problems, and (equivalently) density matrix retrieval and general quantum tomography on larger systems (e.g. 38x38 density matrix retrieval in the $C_2H_4$ case).

Future work is planned to look at these specific problems in more detail, including different energy regions and ionization channels, and other small molecules. As part of this effort, HPC resources will be used to allow for scaling up of the computational effort available, and development of the {{ PEMtk_repo }} and {{ ePSproc_full }} will continue in tandem with these efforts. Fitting strategies, algorithms and methodologies also remain as a large area to be explored, in particular cross-fertilization from other fields dealing with large computational hyperspaces and complex phase-retrieval problems is expected to (continue) to prove fruitful (see {{ QM12 }} and Ref. {cite}`hockett2023TopicalReviewExtracting` for futher discussion along these lines).

As discussed in {numref}`Chpt. %s <sect:platform:analysis>`, it is also hoped that the efforts on the code-development side of the problem, including the case studies presented herein, the open-source nature of the work, and the easy deployment of the full software stack via Docker, will all encourage other researchers to make use of these tools, and make further developments to the methodology and platform. Given the complex nature of both the core physics, data processing, simulation and phase retrieval problems, there are still many avenues to explore, but hopefully the barrier to entry is now significantly lowered.

```{code-cell} ipython3

```
