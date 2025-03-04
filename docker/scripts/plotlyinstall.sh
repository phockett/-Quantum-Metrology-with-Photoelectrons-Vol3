#!/bin/sh

# Quick install for plotly compatibility
# For JupyterLab, need additional extensions - see https://plotly.com/python/getting-started/#jupyterlab-support:
# - `conda install -c conda-forge -c plotly jupyter-dash`
# - `jupyter labextension install jupyterlab-plotly`
#
# In some cases may get partially working installation with, e.g., blank surface plots, or plots via HV only. This usually means JupyterLab needs a restart (and maybe a rebuild).
# For more see https://plotly.com/python/troubleshooting/

# Add extensions
# NOTE kaleido for static figure export - should add to main Dockerfile.
conda install --quiet --yes -c conda-forge -c plotly jupyter-dash python-kaleido


# May need manual install?
# Can check with  jupyter labextension list
jupyter labextension install jupyterlab-plotly

# Force rebuild
jupyter lab build
