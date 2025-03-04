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

**Intro updates 06/07/23**

- Fix broken links etc.
- 24/07/23, added some more glossary terms & links

+++

(chpt:intro)= 
# Introduction

% See also https://phockett.github.io/Quantum-Metrology-with-Photoelectrons-Vol3/intro.html - may want to use more of this and/or streamline this intro with the TLDR version? Not sure on best balance of in-book vs. in-repo/online only.

The overall aim of _Quantum Metrology with Photoelectrons Vol. 3_ is to expand, explore, and illustrate, new computational developments in quantum metrology with photoelectrons: specifically, the application of new python-based tools to tackle problems in matrix element retrieval. The book itself is written as a set of Jupyter Notebooks, hence all the material herein is available directly to readers, and can be run locally to further explore the topic interactively, and provide a foundation which can be adapted to apply the methodology to new problems.

Whilst this volume aims to provide a self-contained text, and focuses on computational examples which may be used without extensive background knowledge, a brief contextual introduction is presented here ({numref}`Sect. %s <sec:topical-intro>` below), and the  necessary core physics,as well as some recent extensions, is also presented herein ({numref}`Chapter %s <chpt:theory>`). The unfamiliar reader is referred to {{ QM1 }} for a more detailed introduction to the physics, and as a more general gateway to the literature. Following the topical introduction, the remainder of Part I introduces the main computational and software tools ({numref}`Chapter %s <chpt:platformIntro>`), recent theory developments ({numref}`Chapter %s <chpt:theory>`), and concludes with a general overview for approaching matrix element retrieval numerically ({numref}`Chapter %s <chpt:numerical-details>`).

Part II details the application of these tools to a few specific cases, including a general guide to setting up and running the {{ PEMtk_repo }} fitting routines (see {numref}`Chapter %s <chpt:extracting-matrix-elements-overview>` for an outline), then proceeding with a (relatively) simple homonuclear diatomic example ({numref}`Chapter %s <chpt:n2-case-study>`), and escalating in complexity to a the most general polyatomic asymmetric top case.

+++ {"tags": ["remove-cell"]}

% General intro notes.

% 13/01/23: mostly complete via quotes. May want to trim and/or expand a bit depending on scope. Probably needs a general tidy too, and possibly refs and figs.

% 06/07/23 version: reviewing.

% TODO: proper reference for video? 06/07/23 - now added in Zotero, didn't push to .bib yet, but added below.

+++

(sec:topical-intro)= 
## Topical introduction: from quantum metrology to a generalised bootstrapping protocol

There are two core topics at the heart of this work, specifically photoelectron spectroscopy (and associated experimental, theoretical and analysis methodologies) and quantum metrology in general. To briefly (re)introduce these topics, and contextually frame the work discussed herein, some brief comments from {{ QM1 }} are reproduced below; the reader is referred to the introductory chapters of {{ QM1 }} for a lengthier treatment, and [an introductory video to *Phase-sensitive Photoelectron Metrology* can be found online](https://vimeo.com/223603377) (see also Refs. {cite}`hockett2017PhasesensitivePEM_DAMOP, hockett2018Bootstrapping_PQE, hockett2016PresentationsArchiveUltrafast` for further introductory presentation videos, materials and resources around the topic).


### Quantum metrology with photoelectrons

To set the general context, consider quantum metrology in general...

```{epigraph}
Quantum metrology can be loosely defined as any class of experiment which provides detailed information on quantum mechanical properties (phases, coherences, entanglement etc.) of a system. To stay with the spirit of modern metrology, this definition can further be refined to measurements which provide high-resolution quantum information; a clear contemporary example is therefore experimental methodologies which provide full quantum state reconstruction (e.g. quantum tomography), and/or make use of quantum mechanical properties as a tool for measurement (e.g. atom interferometry). Traditional high-resolution spectroscopies may also fit within this definition in some cases, although in the majority of cases high-resolution spectroscopic measurements provide transition line-strengths and energies, but lack sufficient information for a full determination or reconstruction of the underlying quantum state.

[...]

...at what point does a measurement of a quantum mechanical system become quantum metrology? A pragmatic view on this is that the complete quantum state of the system must be capable of *unique definition from the experimental measurement(s)*. This is pragmatic in the sense that it leaves the door open for both *inferred* and *direct* reconstruction techniques. In the former case, the experimental data informs the theory and analysis, but is not directly ‘analysed’ or ‘inverted’ to provide or reconstruct the full quantum information; in the latter case one obtains the desired quantum mechanical information from the measurement in a more ‘direct’ fashion (which may, admittedly, still remain as a rather convoluted process, depending on the level of theoretical input required). Traditional spectroscopies again provide a touchstone here - high-resolution spectroscopy measurements can be compared with models or ab initio computations to provide quantum mechanical details of a system, but typically do not directly provide this information from a set of measurements alone. In this sense they fit a pragmatic definition of quantum metrology, but not a more specific definition of quantum metrology as a (somewhat) direct empirical technique.

[...]

In summary, while quantum metrology can come in many flavours, at heart it might be considered as any set of measurements (and associated analysis methodologies) which provide detailed (quantitative) quantum mechanical information on a given system of interest - ideally with little or no restriction on the complexity of the system - and it is discussed in this spirit herein.

-- {{ QM1 }}, Chpt. 1
```

And, for the specific case of photoionization...

```{epigraph}
... both *ab initio* methods and *high-dimensionality measurements* (combined with detailed *analysis methodologies*) can nonetheless provide detailed information on the photoionization dynamics. Although the simple analogy with Young’s double-slit [i.e. basic two-path interferometry] fails, the resulting photoelectron flux, measured spatially, remains, in essence, a self-referencing angular interferogram of the continuum wavefunction. In a more abstract sense, the basic interferometer paradigm can be extended to the general ‘photoionization interferometer’, one just has to keep in mind that there are now potentially many, many channels. In the most basic sense, the energy and angle resolved interferograms - the photoelectron flux as a function of energy and angle $I(E,\theta,\phi)$ - which may be measured, are nothing more than an interferometric measurement sensitive to the relative phases of the different angular momentum components.

[...]

In the photoionization community, the angular interferograms (which will usually be considered at a single energy $E$) are photoelectron angular distributions ({term}`PADs`), and have long been used as a means to learn about the process of photoionization. In this context, {term}`PADs` measured for a range of experimental parameters can provide a dataset with sufficient information content to determine the magnitudes and phases of the photoelectron wavefunction, hence the photoionization dynamics may be reconstructed from the measurements in favourable cases. This class of measurement is traditionally termed a *complete photoionization experiment*, although the exact nature of the completeness may vary. The phase-sensitivity of photoelectron interferograms have also been used in complementary fashions in other contexts, including as a means to probe the phase-shift induced by a specific prepared pathway, and control in multipath schemes, and in many other regimes.

[...]

... the combination of a phase-sensitive quantum mechanical observable - photoelectron interferograms - with modern experimental and computational techniques provides the tools required for a full quantum metrology based on this class of measurement. Following the above discussion and definitions, a full metrology technique is one which allows both the *intrinsic* and *extrinsic/dynamic* quantum mechanical properties of the system under study to be obtained/reconstructed from a measurement, or set of measurements. In the simplest case, one might seek to understand just the intrinsic photoionization dynamics of a scattering system (e.g. the magnitudes and phases of the various pathways [...]), while in more complex cases the intrinsic properties are part of a probe process for additional properties or dynamics of the system [...]. In all cases, the key is measurement (and possibly control) with a high information-content technique, and a detailed understanding of the processes involved.

-- {{ QM1 }}, Chpt. 1
```

In summary, the focus of the work presented herein is the quantitative analysis of phase-sensitive observables from photoionization, specifically photoelectron angular distributions ({term}`PADs`) as a function of energy, angle and time, which will be denoted $I(\epsilon,t,\theta,\phi)$ in general herein. These *photoelectron interferograms* are introducted in more detail (including examples) in {numref}`Sect. %s <sect:theory:observables>`.

% Numref OK here, but ref not working {ref}`<sect:theory:observables>`.

+++

```{figure} ../images/concepts_fig_draft_010417_withAxes.png
---
name: fig-bootstrap-concept-outline
---

Conceptual outline for the generalised {{ BOOTSTRAP }} for {{ RADMATE }}, including retrieval of {{ MF }} properties, via a set of time-resolved measurements and suitable post-processing scheme. In the {{ LF }}/{{ AF }}, a set of laser pulses creates and probes an aligned distribution of molecules, and photoelectron images are measured (as a function of time, hence molecular alignment). The experimental data is analyzed through a multi-step “bootstrap” protocol to obtain matrix elements, which constitute a complete description of the photoionization event. These can further be used to obtain {{ MF }} observables, for any polarization geometry. Note the coordinates show will be used throughout the book, with the {{ LF }} z-axis defined relative to the laser field (E) polarization, and the {{ MF }} defined with the molecular axis aligned along the z-axis (and polarization geometries for the laser field (E) referenced to this axis) - see also {numref}`fig-frame-defns` for a more detailed frame definition.

```

+++

(sec:main-intro:bootstrapping)=
### Generalised geometric metrology protocols

In order to develop a quantitative form of photoelectron spectroscopy, hence analyse photoelectron interferograms in the context of quantum metrology in general, a number of techniques have previously been investigated (see {{ QM12 }}). In general, any applicable technique involves the manipulation or control of parameters which affect the observables in analytically-defined (or otherwise well-characterised) ways; measurements over a set of suitable experimental or control parameters then provide the high information-content dataset required for a full characterisation of the system at hand. Typically, "geometric" (angular-momentum) properties of the system provide a suitable set of control parameters, and a number of experimental methodologies with different flavours of these parameters have been demonstrated (see {{ QM2 }}). The main, outstanding, issue with previous techniques was the system-specific nature of many of the applications: ideally, one would like to make use of a generalised protocol, which is independent of the particulars of the system under study, hence does not require, for example, specific spectroscopic properties to be known and/or be experimentally accessible. 

The main aim of the work in the current volume is the further development, deployment and demonstrations of, such a scheme. The focus is on one specific *high information-content* technique: the *generalised* {{ BOOTSTRAP }}, which makes use of experiments using rotational wavepackets ({{ RWP }}) as a (geometric) control dimension, and time-resolved photoelectron measurements as a high-dimensionality, phase-sensitive observable; the combination of these measurements with a quantitative analysis methodology provides a (relatively) general route to a full quantum metrology with photoelectrons (a.k.a. complete photoionization experiments, a.k.a. quantum state reconstruction/quantum tomography). A brief introduction to the technique is given below, with theoretical and numerical techniques and demonstrations forming the remainder of this book; interested readers can find a longer topical introduction in {{ QM2 }} (in particular Chpt. 11), and see also Ref. {cite}`marceau2017MolecularFrameReconstruction` for an experimental demonstration, and Refs. {cite}`hockett2022TopicalReviewMFpreprint,hockett2023TopicalReviewExtracting` for a recent review in the context of molecular frame reconstruction.

% Note {cite}`hockett2022TopicalReviewMFpreprint` for arXiv/Authorea version of the Topical review.

% A general introduction to the technique can be found in {{ QM2 }} (specifically Chpt. 11, also Sects. 8.2.2, 12.3 & 13.1 for further background discussion and extensions), see also Ref. {cite}`marceau2017MolecularFrameReconstruction` for an experimental demonstration, and Ref. {cite}`hockett2022TopicalReviewExtracting` for a recent review in the context of molecular frame reconstruction.

% Notes from Vol 1/2, or MF recon manuscript go here... or just mention them as refs for more info.
% QM1 S3.1.2 for rot wavepacket theory, S6.1 for an example (butadiene)
% QM2 Sects. as listed above - may want to reproduce fig 8.2 too? Or similar from MF recon manuscript? Or just refer to Numerical implementation chpt?
% Ref some rotational wavepacket papers here? E.g. mine, Tamar's stuff etc.?

As defined in {{ QM2 }}:

```{epigraph}
For the analysis of the data [time-resolved photoelectron images from a rotationally-excited system], a ‘bootstrapping’ fitting approach was developed. This methodology [... is illustrated conceptually in {numref}`fig-bootstrap-concept-outline`, and outlined in more detail in {numref}`fig-bootstrap-fitting-diag` ...] is comprised of two stages (potentially split into multiple steps) which allow for the separation of the two sets of unknowns (rotational and ionization dynamics), and provides a way to gradually bootstrap to the complete {term}`MF` results via stages of analysis of increasing complexity. The nature of the fitting at each stage also provides a flexible methodology which can be used to carefully sample the solution hyperspace in order to ensure unique results, and fit with variable information content (experimental measurements) based on computational time and desired precision, based on a similar Monte-Carlo sampling manner to the methodologies already discussed [...]. In all cases, the underlying physics provides stringent limits on the form of the fitting functions, hence the fitting procedure at each stage is expected to be somewhat reliable by construction. Further analysis of the results, including comparison with experimental parameters, additional data not used in the analysis, and *ab initio* calculations all provide additional means of cross-checking and verifying the extracted physical parameters.

In terms of information content, the bootstrapping procedure gradually increases both the experimental information content - the number of geometric configurations of the photoionization interferometer - and the level of physical information included (hence fitted/extracted) in the analysis. In the first step, {term}`ADMs` [i.e. molecular alignment properties] are determined without the need for accurate treatment of the ionization probe {cite}`Makhija2016a`; in the second step this information is used as part of the calculation to determine the ionization dynamics. In the sub-steps to determine the ionization dynamics, the experimental information content included in the analysis is gradually increased: the initial coarse steps in this procedure provide a base-line high information content, without the necessity for many temporal points, via the selection of highly distinct molecular axis distributions, while latter sub-steps allow for fine-tuning of the data by gradually coupling additional time-steps [or other constraints] into the analysis.

-- {{ QM2 }}, Chpt. 11
```

The protocol as presented relies on certain steps to be experimentally realisable, and theoretically calculable:

1. Molecular alignment. Experimentally, this can be induced in any system with a strong (typically $>10^{12}$~Wcm$^{-2}$), short (few hundred femtosecond timescale or shorter) infra-red laser pulse, which (impulsively) creates a rotational wavepacket in the system. The exact nature of the wavepacket is laser pulse(s) and system dependent, but the technique is general. 
2. Time-resolved photoelectron measurements. Experimentally, this requires - at minumum - a pump-probe type configuration, with the alignment pulse as the pump, and a time-delayed ionization pulse. This is a typical experimental configuration in many ultrafast laser labs, with pulses typically in the atto- or femto-second regime. Measurements may be made by any angle-resolved technique; photoelectron imaging (via velocity-map imaging, {term}`VMI`) is currently the most accessible and widespread method.
3. Data analysis. This provides the bridge from high information-content measurements to a full quantum 
metrology (system characterisation). For the generalised bootstrapping approach this requires:
   
   * In order to characterise the rotational wavepacket created, alignment calculations of the system must be possible - such computations are increasingly tractable, if not already (somewhat) routine for a number of groups, although quite challenging and computational expensive for asymmetric top systems. These calculations are required in order to determine the rotational wavepacket ({{ RWP }}) quantitatively, and in order to determine the corresponding {{ ADMs }} from/for the experiment. {{ RWP }} computation is beyond the scope of the current work, but their use in the bootstrapping protocol is discussed in {numref}`Chapter %s <chpt:numerical-details>`.
   * To characterise the _intrinsic_ photoionization dynamics, a set of appropriate geometric basis functions must be computed, and combined with a sufficiently large dataset to enable extraction of the photoionization matrix elements via a fitting procedure. This is the main focus of Part II herein.
   * (Optional) In cases with _extrinsic_ dynamics, these may further be analysed once the _intrinsic_ dynamics have been characterised (or as part of that characterisation); this may, however, remain qualitative or semi-quantitative, depending on the system dynamics and complexity. This aspect of photoelectron metrology is beyond the scope of the current work, see discussion in {{ QM2 }} for more discussion; recent examples of such work may be found in Refs. {cite}`makhija2020UltrafastMolecularFrame, morrigan2023UltrafastMolecularFrame`, which investigated coherent electronic dynamics and complete quantum tomography of such a case.

% May want to add more refs above? Note also 3.a, 3.b... style list formatting not working in Markdown > HTML, so now set to unordered list. Can use HTML formatting, see https://stackoverflow.com/questions/13366820/how-do-you-make-lettered-lists-using-markdown.
   
4. (Optional) _Ab initio_ computations may also be performed to compare with any or all of the previous steps; comparison with step 3 is particularly powerful, since one can compare fundamental quantum mechanical properties, as opposed to comparisons between measured and simulated observables, which may be integrated over many degrees of freedom of the system.

As detailed in the following section ({numref}`Sect. %s <sec:intro-context>`), the main aims herein are the development of the methodology and toolkit to address the data analysis requirement (step 3), and to test this methodology for a range of example cases.

% *** Moved to context and aims section
% The work in the current volume primarily addresses some of the extensions towards a generalised bootstrapping protocol as outlined in {{ QM2 }} Sect. 12.3; in particular the new {{ PEMtk_repo }} has been built with the aim of making the protocol easy to use and apply to any given problem (as distinct from a bespoke/per-experiment analysis methodology and/or non-open-source codebase). Part I herein includes a full precis of the theory implemented towards this end, and Part II provides multiple demonstrations of the new codebase, and includes use of the toolkit to investigate more complex systems beyond the simplest homonuclear diatomic case.

% May be sufficient, or need a little more detail here - depends a bit on latter chpts. and also the top of this intro.
% Also mention tomography stuff? \cite{morrigan2022UltrafastMolecularFrame}

+++

(sec:intro-context)= 
## Context & aims for Vol. 3

### Scientific aims

The work in the current volume primarily addresses recent developments towards a generalised bootstrapping protocol (i.e. the analysis of the data obtained by time-resolved photoelectron imaging measurements - or similar - from a rotationally-excited system), as previously outlined in {{ QM2 }} Sect. 12.3; in particular the new {{ PEMtk_repo }} has been built with the aim of making the protocol easy to use and apply to any given problem (as distinct from a bespoke/per-experiment analysis methodology and/or non-open-source codebase). 

Part I herein includes a full precis of the new codebase ({numref}`Chapter %s <chpt:platformIntro>`), along with the theory ({numref}`Chapter %s <chpt:theory>`) and numerics ({numref}`Chapter %s <chpt:numerical-details>`) implemented towards this end; {{ PARTII }} provides multiple demonstrations of the new code-base, including the use of the toolkit to investigate more complex systems beyond the simple homonuclear diatomic case demonstrated to date.

Although the analysis herein focuses on the {{ RWP }} case, the techniques and codebase developed are equally applicable to *any methodology or protocol making use of geometric properties as a variable*, and are built with all such problems in mind - although minor modifications or extensions may be required for specific cases. Examples include other cases discussed in {{ QM12 }}, e.g. the use of shaped laser pulses or the use of narrow-band, state-selected rotational excitation; in all cases the fitting/retrieval of matrix elements is carried out in the same manner, and the only changes required to the methodology are the choice of control variable and the corresponding input experimental or theoretical parameters - this is discussed further in {numref}`Sect. %s <sect:numerics:fitting-strategies>`. 

% Ref to Part II, Chpt. 4 on future directions?

(sec:intro-technical-notes)=
### Technical context and notes 

% v2 with clarifications and list formatting
% 06/07/23: added links for Sphinx etc. directly here, may want to configure as proper refs.

As noted previously, Vol. 3 is somewhat distinct from the previous volumes in the series; although involving computational elements, {{ QM12 }} are more traditional publications. The material presented in this volume aims to continue the exploration of quantum metrology with photoelectrons, with a focus on numerical analysis techniques, forging a closer link between experimental and theoretical results, and making the methodologies discussed directly accessible via a new software platform/ecosystem, {{ PEMtk_repo }}, introduced in more detail in {numref}`Chapter %s <chpt:platformIntro>`. 
In order to fulfill this aim, Vol. 3 is an open source computational/computable document, with code directly available to readers to facilitate code transparency and reuse. This can be broken down as follows:

1. The book itself is written as a set of [Jupyter Notebooks](https://jupyter.org) {cite}`ProjectJupyter`.[^jupyterFootnote]  
    * These are `.ipynb` files, usually running a [Python kernel](https://www.python.org/) {cite}`PythonOrgWebsite`, each of which is designed such that it can be modified and used independently.
    * The full book is compiled from these sections using the [Jupyter Book](https://jupyterbook.org/) {cite}`JupyterBookProject,community2020JupyterBook` project platform,[^jupyterBookFootnote] which includes build tools and specifications for the specific flavour of [Markdown (MyST)](https://mystmd.org/) {cite}`MySTMarkdownTools` used for the written text, and uses [Sphinx](https://www.sphinx-doc.org) {cite}`SphinxDocumentation` to build HTML and Latex/PDF flavours of the book.
    * The book source code is available via a Github repository, {{ book_repo }}, which includes all the notebooks (in the `doc-source` directory), as well as installation and build notes for building the book itself. 
    * An HTML version is also available at {{ book_HTML }}, which includes interactive figures.
2. The code examples _within_ the book make use the new {{ PEMtk_repo }}.
    * In order to run code examples, a specific python environment (with various additional python packages) is required.
    * A full introduction to the relevant software tool-chain, including installation instructions for the codes used _within_ the book, can be found in {numref}`Chapter %s: <chpt:platformIntro>` {ref}`chpt:platformIntro`.
    * For a quick and easy installation, including all requirements, a Docker build  of the platform can also be used, see {numref}`Sect. %s: <sect:platform:docker>` {ref}`sect:platform:docker` (see also the {{ open_photo_stacks_repo }} for more related tools).
    * Once configured, any code examples from the book can be executed locally by the user/reader, and modified as desired. Each notebook is designed to be run as a stand-alone computational document.
3. The book can be regarded as, essentially, a manual and introduction to the {{ PEMtk_repo }}, as well as a foundation for those wishing to use (and potentially extend) the platform.
    * Part I covers all required background material, including details of the theory and numerical methods implemented.
    * Part II contains various examples of usage for a range of problems, and possible extensions.
    * Since no specific knowledge of the underlying physics should be required to use the software tools, they will hopefully also provide a suitable platform for new researchers wishing to learn about photoionization in general. 
    * It is, of course, also hoped that established researchers in the field will find the tools useful, and readily adaptable, to related problems of interest.
    * Further documentation for the software tools (including the full PEMtk API) can be found online in the {{ PEMtk_docs }}.

Finally, it is of note that whilst readers unfamiliar with the Jupyter and Python ecosystem may find that there is somewhat of a barrier to entry for making use of the platform, it is one that may be worth surmounting given the ubiquity of these tools, and general usefulness in modern scientific/data-science workflows; readers already making use of these tools in their work should have no difficultly, and the platform adheres to standard practice wherever possible. For an introduction to Python for data science, the [Python Data Science Handbook](https://github.com/jakevdp/PythonDataScienceHandbook) provides a solid introduction, and is itself [an open source textbook available via Github](https://github.com/jakevdp/PythonDataScienceHandbook) {cite}`vanderplas2016PythonDataScience, vanderplasPythonDataScienceBookGithub`.

+++

(sect:intro:open-science)=
### A brief note on open science, open source software and reproducibility

% Here or in code intro chpt?  See ePSdata for text? Or recent publications with some open science TOP blurb.

A large part of the motivation for creating new tools, making them open source, and standardized, is down to the nature of the modern scientific endeavour, and the difficulty of reproducibility. In short, many projects now involve a substantial element of analysis making use of in-house codes, which are often inaccessible to other researchers; the same may apply to the raw datasets used. Whilst this may be justified in some cases, in general it leads to a lack of transparency and portability for the computational and/or data component(s) of research. The Open Science movement, in part, aims to challenge these issues - see, for further discussion, Refs. {cite}`Barnes2010, mcnutt2016TakingTOP, Nosek2015, StateOpenData2016, Stodden2014, Downs2015, howison2015UnderstandingScientificSoftware`, or the [Wikipeadia Open Science page](https://en.wikipedia.org/wiki/Open_science) for a brief summary {cite}`wikipeadiaOpenScience`. 

As noted above, this book is fully open-source, including the full book source code, the computational libraries used and the datasets illustrated herein, and available via {{ book_repo }}; this is detailed further in {numref}`Sect. %s <chpt:platformIntro>`. In order to aid portability and reproducibility, Docker builds are also available: these provide a means to define a full computational platform/stack, from the OS level and up, including all necessary dependencies and version; further details can be found in {numref}`Sect. %s <sect:platform:docker>`.

In general, it is hoped that making such tools more accessible, usable, and interconnected - as well as making computational data generally available - will lower the barrier to entry to the field and create a useful foundation for interested researchers to work from.

+++

% Footnotes hopefully

[^jupyterFootnote]: For more information on the [Jupyter Project and ecosystem](https://jupyter.org), see [jupyter.org](https://jupyter.org) and Refs. {cite}`ProjectJupyter,kluyver2016JupyterNotebooksPublishing,granger2021JupyterThinkingStorytelling`.)

[^jupyterBookFootnote]: For more information see [jupyterbook.org](https://jupyterbook.org) and Refs. {cite}`JupyterBookProject,community2020JupyterBook`.
