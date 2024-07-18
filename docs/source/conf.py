#!/usr/bin/env python3
import sys
import os

project = 'YosysHQ Yosys'
author = 'YosysHQ GmbH'
copyright ='2024 YosysHQ GmbH'
yosys_ver = "0.42"

# select HTML theme
html_theme = 'furo'
templates_path = ["_templates"]
html_logo = '_static/logo.png'
html_favicon = '_static/favico.png'
html_css_files = ['yosyshq.css', 'custom.css']

html_theme_options = {
    "sidebar_hide_name": True,

    "light_css_variables": {
        "color-brand-primary": "#d6368f",
        "color-brand-content": "#4b72b8",
        "color-api-name": "#8857a3",
        "color-api-pre-name": "#4b72b8",
        "color-link": "#8857a3",
    },

    "dark_css_variables": {
        "color-brand-primary": "#e488bb",
        "color-brand-content": "#98bdff",
        "color-api-name": "#8857a3",
        "color-api-pre-name": "#4b72b8",
        "color-link": "#be95d5",
    },
}

# These folders are copied to the documentation's HTML output
html_static_path = ['_static', "_images"]

# code blocks style 
pygments_style = 'colorful'
highlight_language = 'none'

extensions = ['sphinx.ext.autosectionlabel', 'sphinxcontrib.bibtex']

if os.getenv("READTHEDOCS"):
    # Use rtds_action if we are building on read the docs and have a github token env var
    if os.getenv("GITHUB_TOKEN"):
        extensions += ['rtds_action']

        # The name of your GitHub repository
        rtds_action_github_repo = "KrystalDelusion/yosys"

        # The path where the artifact should be extracted
        # Note: this is relative to the conf.py file!
        rtds_action_path = "."

        # The "prefix" used in the `upload-artifact` step of the action
        rtds_action_artifact_prefix = "cmd-ref-"

        # A GitHub personal access token is required for full RTD builds
        rtds_action_github_token = os.environ["GITHUB_TOKEN"]
    else:
        # We're on read the docs but have no github token, this is probably a PR preview build
        html_theme_options["announcement"] = "<strong>Oh no!</strong> This looks like a ReadTheDocs build, possibly for a PR preview, that's missing some generated content!"
        html_theme_options["light_css_variables"]["color-announcement-background"] = "var(--color-admonition-title-background--caution)"
        html_theme_options["light_css_variables"]["color-announcement-text"] = "var(--color-content-foreground)"

# Ensure that autosectionlabel will produce unique names
autosectionlabel_prefix_document = True
autosectionlabel_maxdepth = 1

# set version
if os.getenv("READTHEDOCS") and os.getenv("READTHEDOCS_VERSION") == "latest":
    release = yosys_ver + "-dev"
else:
    release = yosys_ver

# assign figure numbers
numfig = True

bibtex_bibfiles = ['literature.bib']
latex_elements = {
        'releasename': 'Version',
        'preamble': r'''
\usepackage{lmodern}
\usepackage{comment}

'''
}

# include todos during rewrite
extensions.append('sphinx.ext.todo')
todo_include_todos = False

# custom cmd-ref parsing/linking
sys.path += [os.path.dirname(__file__) + "/../"]
extensions.append('util.cmdref')

def setup(sphinx):
	from util.RtlilLexer import RtlilLexer
	sphinx.add_lexer("RTLIL", RtlilLexer)

	from util.YoscryptLexer import YoscryptLexer
	sphinx.add_lexer("yoscrypt", YoscryptLexer)