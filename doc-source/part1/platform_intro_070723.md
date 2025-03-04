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

v 07/11/22

- STUB
- Adapted from MFrecon article, Numerical implementation sect.

v 07/07/23

- Reviewing and expanding.
- TODO: include more detailed installation and build notes here, as appendix, or in the repo?
    - Some basic notes now in place.
    - Very basic guide currently in main readme.
    - JUST SCRIPT IT? (See Dockerfile?)  https://github.com/phockett/Quantum-Metrology-with-Photoelectrons-Vol3 readme also has a very basic version!

+++

(chpt:platformIntro)=
# Quantum metrology software platform/ecosystem overview

+++

In recent years, a unified Python codebase/ecosystem/platform has been in development to tackle various aspects of photoionization problems, including *ab initio* computations and experimental data handling, and (generalised) matrix element retrieval methods. The eponymous _Quantum Metrology with Photoelectrons_ platform is introduced here, and is used for the analysis herein. The main aim of the platform is to provide a unifying data layer, and analysis routines, for photoelectron metrology, including new methods and tools, as well as a unifying bridge between these and existing tools. {numref}`qm-platform-diag` provides a general overview of some of the main tools and tasks/layers.

As of late 2022, the new parts of the platform - primarily the {{ PEMtk_repo }} library - implement general data handling for theory and experimental datasets (although not a full experimental analysis toolchain), along with matrix element handling and retrieval, which will be the main topic of this volume.
In the future, it is hoped that the platform will be extended to other theoretical and experimental methods, including full experimental data handling.

(sect:platform:analysis)=
## Analysis components

The two main components of the platform for analysis tasks, as used herein, are:

-   The {{ PEMtk_repo }} (PEMtk) codebase aims to provide various general data handling routines for photoionization problems. At the time of writing, simulation of observables and fitting routines are implemented, along with some basic utility functions.
    Much of this is detailed herein, and more technical details and ongoing documentation case be found in the {{ PEMtk_docs }}.

-   The {{ ePSproc_full }} aims to provide methods for post-processing with *ab initio* radial dipole matrix
    elements from {{ ePS_full }}, or equivalent matrix elements from other sources (dedicated support for R-matrix results from [the RMT suite](https://gitlab.com/Uk-amor/RMT/rmt) {cite}`brown2020RMTRmatrixTimedependence,RmatrixRepo` is in development, for an overview of *ab initio* methods/packages see Ref. {cite}`dowek2022TrendsAngleresolvedMolecular`). 
    The core functionality includes the computation of AF and MF observables. Manual computation without known matrix elements is also possible, e.g. for investigating
    limiting cases, or data analysis and fitting - hence these routines also provide the backend functionality for PEMtk fitting routines. Again more technical details can be found in the {{ ePSproc_docs }}.
    
````{margin}
```{warning}
As {ref}`noted elsewhere <sec:numerics:disclaimer>`, many components of the toolkit are still in active development, and some numerical details may change.
```
````

+++

```{figure} ../images/QM_unified_schema_wrapped_280820_gv.png
---
name: qm-platform-diag
---
Quantum metrology with photoelectrons ecosystem overview.
```

+++ {"jp-MarkdownHeadingCollapsed": true}

(sect:platform:otherTools)=
## Additional tools

Other tools listed in {numref}`qm-platform-diag` include:

* Quantum chemistry layer. The starting point for *ab initio* computations. Many tools are available, but for the examples herein, all computations made use of [Gamess ("The General Atomic and Molecular Electronic Structure System")](http://www.msg.ameslab.gov/gamess/) {cite}`gamess, Gordon` for electronic structure computations, and inputs to ePolyScat.
   * For a python-based approach, various packages are available, e.g. [PySCF](https://pyscf.org), [PyQuante](https://pyquante.sourceforge.net/), [Psi](https://psicode.org) can be used for electronic structure calculation, although note that some {{ ePSproc_repo }} routines currently require Gamess files (specifically for visualisation of orbitals).
   * A range of other python tools are available, including [cclib](https://cclib.github.io/) for file handling and conversion, [Chemlab](https://chemlab.readthedocs.io) for molecule wavefunction visualisations, see further notes below.
* {{ ePS_full }} is an open-source tool for numerical computation of electron-molecule scattering & photoionization by Lucchese & coworkers. 
    * All matrix elements used herein were obtained via ePS calculations. For more details see {{ ePS_manual }} and Refs. {cite}`Lucchese1986,Gianturco1994,Natalense1999`.
    * A [Docker build is available](https://github.com/phockett/open-photoionization-docker-stacks/tree/main/ePolyScat) (via the {{ open_photo_stacks_repo }} project).
    * ePS (along with a range of other computational AMO tools) is also available online via the [AMOS gateway](https://amosgateway.org/) [^AMOSgatewayFootnote] {cite}`AMOSGateway, schneider2020AtomicMolecularScattering, schneider2020ScienceGatewayAtomic`.
    
* {{ ePSdata_docs }} is an open-data/open-science collection of ePS + ePSproc results.
    * ePSdata collects ePS datasets, post-processed via ePSproc (Python) in [Jupyter notebooks](https://jupyter.org), for a full open-data/open-science transparent pipeline.
    % * ePSdata is currently (Jan 2020) collecting existing calculations from 2010 - 2019, from the [femtolabs at NRC](http://femtolab.ca), with one notebook per ePS job.
    % * In future, ePSdata pages will be automatically generated from ePS jobs (via the ePSman toolset, currently in development), for immediate dissemination to the research community.
    * Source notebooks are available on the {{ ePSdata_repo }} [Github project repository](https://github.com/phockett/ePSdata/), and notebooks + datasets via {{ ePSdata_zenodo }}. Each notebook + dataset is given a Zenodo DOI for full traceability, and notebooks are versioned on Github.
    * Note: ePSdata may also be linked or mirrored on the existing [ePolyScat Collected Results OSF project](https://osf.io/psjxt/), but will effectively supercede those pages.
    * All results are released under [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 (CC BY-NC-SA 4.0) license](https://creativecommons.org/licenses/by-nc-sa/4.0/), and are part of an ongoing [Open Science initiative](http://femtolab.ca/?p=877).
    
[^AMOSgatewayFootnote]: Formerly known as the AMP gateway.

+++

(sect:platform:pythonEcosystem)=
## Python ecosystem (backends, libraries and packages)

The core analysis tools, which constitute the {{ PEMtk_repo }} platform, are themselves built with the aid of a range of open-source python packages/libraries which handle various backend functionality. Notably, they make use of the following key packages:

* General functionality makes use of the usual "Scientific Python" stack, in particular: 
   * [`Numpy`](https://numpy.org/) {cite}`NumPy` for general numerical methods and data types.
   * [`pandas`](https://pandas.pydata.org/) {cite}`PandasPythonData` for statistical methods, and various tabulation and sorting tasks.
   * {{ scipy }} for some special functions and computational routines, particularly spherical harmonics and fitting routines (see below).
* General ND-array and tensor handling and manipulation makes use of the [`Xarray` library](https://docs.xarray.dev) {cite}`hoyer2017XarrayNDLabeled,XarrayDocumentation`.
* Angular momentum functions
    * Wigner D and 3js are currently implemented directly, or via the [Spherical Functions library](https://github.com/moble/spherical_functions) {cite}`boyle2022SphericalFunctionsGithub, boyle2023MobleSphericalFunctions`, and have been tested for consistency with the definitions in Zare (for details see [the ePSproc docs](https://epsproc.readthedocs.io/en/latest/tests/Spherical_function_testing_Aug_2019.html) {cite}`ePSprocDocs`). The Spherical Functions library also uses [`quaternion`](https://github.com/moble/quaternion) {cite}`boyle2023MobleQuaternionRelease, MobleQuaternionGithub` which implements a quaternion datatype in Numpy.
    * Spherical harmonics are defined with the usual physics conventions: orthonormalised, and including the Condon-Shortley phase. Numerically they are implemented directly or via SciPy's `sph_harm` function (see [the SciPy docs for details](https://docs.scipy.org/doc/scipy/reference/generated/scipy.special.sph_harm.html) {cite}`SciPyDocumentation`. Further manipulation and conversion between different normalisations can be readily implemented with the [`pySHtools` library](https://shtools.github.io/SHTOOLS/) {cite}`SHtoolsGithub, wieczorek2018SHToolsToolsWorking, wieczorek2019SHTOOLSSHTOOLSVersion, wieczorek2022SHtoolsDocs`. See {numref}`Sect. %s <sec:theory:sph-harm-intro>` for examples.
    * Symmetry functionality, specifically computing symmetrized harmonics $X_{hl}^{\Gamma\mu*}(\theta,\phi)$ (see Eq. {eq}`eq:AF-PAD-general`), makes use of {{ libmsym }} (symmetry coefficients) and {{ shtools }} (general spherical harmonic handling and conversion).  See {numref}`Sect. %s <sec:theory:sym-harm-into>` for examples.
* Non-linear optimization (fitting), as used for the {{ BOOTSTRAP }} (to determine {{ RADMATE }}):
    * Fitting is handled via the {{ lmfit }}, which implements and/or wraps a range of non-linear fitting routines in Python, including classes for handling fitting parameters and outputs. In this work only the Levenberg-Marquardt least-squares minimization method has been used, which wraps [Scipy's `least_squares` functionality](https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.least_squares.html) {cite}`SciPyDocumentation`, hence this is the core numerical minimization routine for the demonstration cases herein. (See {numref}`Chapter %s <chpt:numerical-details>` for further discussion of fitting methods.)
    * Basic parallelization for fitting routines is implemented using the [`xyzpy`](https://xyzpy.readthedocs.io/en/latest/) library {cite}`XyzpyDocumentation`, see {numref}`Chapter %s <sect:basic-fit-setup>` for further details.

* For plotting a range of tools can be used, some of which are implemented/wrapped in the {{ PEMtk_repo }}, or can be used directly with `Xarray` data structures, including: 
    * [`Matplotlib`](https://matplotlib.org/) {cite}`MatplotlibVisualizationPython`: basic plotting, including [`Xarray` direct plotters](https://docs.xarray.dev/en/stable/user-guide/plotting.html).
    * [`Holoviews`](https://holoviews.org/) {cite}`HoloViewsDocumentation`: used for data handling and interactive plotting, Holoviews is a general plotting tool which wraps various backends; [`hvplot`](https://hvplot.holoviz.org/) {cite}`HvPlotDocumentation` can also be used to provide additional `Pandas` and `Xarray` integration for Holoviews. Most of the plots herein use Holoviews. 
    * [`Bokeh`](https://bokeh.org/) {cite}`Bokeh`: used for interactive plots, implemented in the {{ PEMtk_repo }} via Holoviews wrappers/methods.
    * [`Plotly`](https://plotly.com/) {cite}`Plotly`: used in the the {{ PEMtk_repo }} and the {{ ePSproc_full }} for spherical polar plotting routines.
    * [`Seaborn`](https://seaborn.pydata.org/) {cite}`SeabornDocumentation, waskom2021SeabornStatisticalData`: used for statistical methods and some specialist plots and styles, particularly the [`lmPlot` routine](https://epsproc.readthedocs.io/en/dev/demos/ePSproc_demo_matE_plotting_Feb2020.html#Plotting-maps-with-lmPlot) in {{ ePSproc_full }}.

* Some specialist (optional) tools also make use of additional libraries, although these are not required for basic use; in particular:
   * For 3D orbital visualizations with {{ ePSproc_repo }}: [pyvista](https://docs.pyvista.org/) for 3D plotting (which itself is built on VTK), [cclib](https://cclib.github.io/) for electronic structure file handling and conversion, and methods based on [Chemlab](https://chemlab.readthedocs.io) for molecule wavefunction (orbital) computation from electronic structure files are all used on the backend.
   * [`Numba`](https://numba.pydata.org/) {cite}`NumbaHighPerformance` is used for numerical acceleration in some routines, although remains mainly experimental in `ePSproc` at the time of writing (an exception to this is the Spherical Functions library, which does make full use of Numba acceleration).

Code examples and further comments can be found as and when numerical examples are introduced in the text, particularly in {numref}`Chapter %s <chpt:theory>` and {numref}`Chapter %s <chpt:numerical-details>`.

+++

(sect:installation)=
## Installation and environment set-up

### Quick-start installation

% TODO: script this and demo here, see https://github.com/phockett/Quantum-Metrology-with-Photoelectrons-Vol3 readme for a very basic version!

For a basic installation, up-to-date version of {{ PEMtk_repo }} and {{ ePSproc_full }} can be installed directly from Github source using pip:

```
pip install git+https://github.com/phockett/ePSproc.git
pip install git+https://github.com/phockett/PEMtk.git

```

This should also install the required dependencies, although not all of the optional packages. (Note that `pip install ePSproc` will also work, and install the latest release from [the Pypi repository](https://pypi.org/project/ePSproc/), but this may not be fully up-to-date compared to the Github source; `PEMtk` is not yet available via Pypi.)

For more details and other installation options, see the [ePSproc extended installation notes online](https://epsproc.readthedocs.io/en/latest/etc/installation_notes_051120.html), which includes directions for virtual environments (Anaconda, Venv).

To obtain the book source, including all example notebooks, simply use Git:

```
git clone https://github.com/phockett/Quantum-Metrology-with-Photoelectrons-Vol3.git
```

Alternatively, the files can be browsed and download via the web from the {{ book_repo }}, which also includes additional setup notes.


(sect:platform:docker)=
### Docker deployments

[Docker](https://www.docker.com/) {cite}`DockerWebsite` provides a useful mechanism for distribution of software as stand-alone containers (essentially minimal virtual machines), including definitions and versioning for everything from the operating system layer and up. Docker containers are both portable and reproducible, hence excellent tools for open science (see {numref}`Sect. %s <sect:intro:open-science>`).

A Docker-based distribution of various codes for tackling
photoionization problems is available from the {{ open_photo_stacks_repo }}
project, which aims to make a range of these tools more accessible to
interested researchers, and fully cross-platform/portable. The project currently includes Docker builds for `ePSproc` and `PEMtk` (as well as `ePS` and other useful tools). These are based on the [Jupyter Docker Stacks project](https://jupyter-docker-stacks.readthedocs.io) {cite}`JupyterDockerStacks`, which includes Jupyter Lab, and also add all the required tools for the work illustrated herein.

A Docker container for this book is [also available from the Docker Hub](https://hub.docker.com/r/epsproc/quantum-met-vol3) (and source Dockerfiles via {{ book_repo }}). This container builds on the `ePSproc` and `PEMtk` container, and additionally includes the source notebooks and build tools (specifically [Jupyter Book](https://jupyterbook.org/) {cite}`JupyterBookProject,community2020JupyterBook` and related tools) as discussed in  {numref}`Sect. %s <sec:intro-technical-notes>`. It is suggested that readers interested in making use of this work start here as the easiest - and most comprehensive - methodology for getting the tools up and running. Docker uses simply need to run `docker pull epsproc/quantum-met-vol3` to obtain a copy, and `docker run epsproc/quantum-met-vol3` to run - for further details and notes see the [Docker section](https://github.com/phockett/Quantum-Metrology-with-Photoelectrons-Vol3/tree/main/docker) of {{ book_repo }}.

% TODO: include build notes here, as appendix, or in the repo? Very basic guide currently in main readme. UPDATED 24/10/23 with basics and additional links to instructions.


### Running examples

Any of the source notebooks can be run individually in a correctly configured Python/Jupyter environment (readers unfamiliar with Jupyter [can find introductory materials online at jupyter.org](https://jupyter.org) {cite}`ProjectJupyter`). Note that the majority of the imports are handled by a setup script, executed at the top of each notebook, for brevity and to ensure a standardized build:

```
%run '../scripts/setup_notebook.py'
```

For additional customization this script can be modified as desired. Depending on the build environment the full path to the script may also need to be set (the current code assumes the script will be located in the `qm3-repo/doc-source/scripts` directory, and notebooks run from their source dirs, e.g. `qm3-repo/doc-source/part1`).

% TODO: fix this, should be able to set from working dirs...?

+++

(sect:platform:general)=
## General platform discussion

Note that, at the time of writing:

* Rotational wavepacket simulation is not yet implemented in the {{ PEMtk_repo }}, and these must be obtained via other codes. An intial build of the [`limapack` suite](https://github.com/jonathanunderwood/limapack) {cite}`underwood2021Limapack` for rotational wavepacket simulations is currently part of the {{ open_photo_stacks_repo }}, but has yet to be used in this work.
* Fitting:
   * Fitting methods have not yet been carefully optimized, with only a general non-linear least squares method implemented. However, other methods should be easy to implement, either via the {{ lmfit }} or with other Python libraries or custom codes; optimization making use of `Numba` should also be possible.
   * Only the {{ BOOTSTRAP }} is currently implemented in {{ PEMtk_repo }}, along with associated analysis routines. However, the routines were written to be general and modular, so modification of the routines to other retrieval schemes should be fairly easy, and usually requires only (a) a function which computes the required basis set (e.g. {{ GAMMACHANNEL }})  and (b) observables for the problem at hand. Examples are given in {{ PARTII }} for the *generalised {{ BOOTSTRAP }}*, and {{ MF }}-{{ PADs }} based retrieval is also implemented in the codebase. For further details see the {{ PEMtk_docs }}, particularly the [fitting model backends](https://pemtk.readthedocs.io/en/latest/fitting/PEMtk_fitting_backends_demo_010922.html) and [fitting MF and other datasets](https://pemtk.readthedocs.io/en/latest/fitting/PEMtk_fitting_demo_multi-fit_tests_130621-MFtests_120822-tidy-retest.html) pages.
* The {{ PEMtk_repo }} codebase is currently still under heavy development, so readers may wish to consult the ongoing {{ PEMtk_docs }} in future for changes and updates.
* For specific guides to various aspects of both codebases, see the relevant docs, which include full API guides. Some particular materials of introductory interest include:
  * A general quick-start demo can be found in the {{ ePSproc_docs }}, [specifically the ePSproc class intro page](https://epsproc.readthedocs.io/en/latest/demos/ePSproc_class_demo_161020.html).
  * For more details of the data structures used, see the {{ ePSproc_docs }}, specifically the [data structures page](https://epsproc.readthedocs.io/en/latest/dataStructures/ePSproc_dataStructures_demo_070622.html).

Nonetheless, although both the codebase and methodologies are still under development, a range of numerical methods have been successfully trialled (as illustrated in {{ PARTII }} herein), and are now available to other researchers to make use of and build on.

```{code-cell} ipython3

```
