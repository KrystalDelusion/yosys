Building the documentation
==========================

A portion of the documentation is generated dynamically by using Yosys during
the build process.

More stuff here.

PR previews and limitations
---------------------------

Because we are building from the Yosys repo, we can preview PRs (like this
one!).

As described above, some of the content in the documentation is generated
dynamically.  While this has the benefit of always staying up-to-date with the
latest version of Yosys (including any local changes you might make), it does
mean that some parts of the documentation will be missing when using the Read
the Docs PR preview feature.  This includes most images that are generated from
:cmd:ref:`show`, some other images that are built from ``.tex`` source, as well
as all of the :doc:`/cmd_ref` and the upcoming cell reference.

`YosysHQ/Yosys#4376`_ adds a step to the test docs action which not only
attempts to build the docs with the Yosys build being tested, but it will also
then upload artifacts for both the pdf and html builds.  If the PR being
(p)reviewed changes this generated content then it is possible to download these
artifacts to check the Sphinx output (see: the corresponding `action run`_ from
the PR referenced, although the artifacts for it are expired and no longer
available).  Note that the current version in that PR only builds Yosys without
Verific, if documentation changes for Yosys+Verific are expected then it would
be reasonably straight-forward to update `test-verific.yml` instead.

.. _YosysHQ/Yosys#4376: https://github.com/YosysHQ/yosys/pull/4376
.. _action run: https://github.com/YosysHQ/yosys/actions/runs/9246974933
