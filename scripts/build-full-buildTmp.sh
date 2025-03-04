#!/bin/sh

# Quick local build for QM3 book from source
#
# 23/11/22: #Version for full rebuild, HTML & PDF, to clean dir tree.
#
# CURRENTLY FAILING FOR PDF 23/11/22 pm, although worked this morning (and main build pdf OK)?
# ISSUE WITH PATHS OR SOMETHING SOMEWHERE>>>>??????
#
# For more options see https://jupyterbook.org/en/stable/basics/build.html
#
# TODO: may want to add ghpages push here (for git config see https://gist.github.com/qin-yu/bc26a2d280ee2e93b2d7860a1bfbd0c5)
# OR: set Git for output upload only & GH actions for deploy - probably cleaner. ("_latest_build" in .gitignore for now)
# 
#           IF FAILING, try `conda activate` in current terminal
#

# Set default path, or pass at CLI
# BASEPATH="${1:-~/QM3}"
BASEPATH="${1:-/home/jovyan/QM3}"
TMPDIR="/home/jovyan/jake-home/buildTmp"
BUILDSOURCE="$TMPDIR/_latest_build"
SOURCE="doc-source"

cd $BASEPATH

echo "Running FULL Jupyter book builds from $BASEPATH - Clean builds and copy version"

# *** Build HTML
export BUILDENV=html
BUILDDIR=$BUILDSOURCE/$BUILDENV
REFDIR="$BUILDSOURCE/$BUILDENV-build"

echo "*** Copying source files from doc-source to $BUILDDIR"
if [ -d "$BUILDDIR" ]; then rm -Rf $BUILDDIR; fi
mkdir -p $BUILDDIR

# COPY only required files - easy to miss stuff here
# cp doc-source/* --parents $BUILDSOURCE
# cp doc-source/**/*.ipynb --parents $BUILDSOURCE
# COPY full dir, then remove .md
cp $SOURCE/ -r $BUILDDIR
rm -r $BUILDDIR/$SOURCE/_build   # Ensure clean build, having issues otherwise...?
# echo Removing .md from subdirs using $BUILDSOURCE/doc-source/**/*.md 
# rm $BUILDSOURCE/doc-source/**/*.md

# Clean - should set as option
echo "*** Cleaning $BUILDDIR"
jupyter-book clean $BUILDDIR/$SOURCE/

# 24/10/23 - added set intro pages here
echo "*** Setting intro to intro_web.md"
ln -s -f $BUILDDIR/$SOURCE/intro_web.md $BUILDDIR/$SOURCE/intro.md

# 24/10/23 - script injection to fix Mathjax in pages without maths
echo "*** Injecting Mathjax..."
filesScript=("backmatter/bibliography.md" "frontmatter/about_the_authors.md" "frontmatter/abstract.md" "frontmatter/book_versions_note.md" "part1/theory_100723.md" "tests/build_versions_checks.md")

for originalFile in "${filesScript[@]}"
do
    cp $BUILDDIR/$SOURCE/$originalFile $BUILDDIR/$SOURCE/$originalFile.noscript
    cat $TMPDIR/scripts/mathjax_patch.txt >> $BUILDDIR/$SOURCE/$originalFile $BUILDDIR/$SOURCE/$originalFile 
done

# Remove downloads - MAY WANT TO DO THIS FOR CLEAN OUTPUT IN CASE STUDIES, but may mess up other chpts. using these?
# echo "*** Removing case study downloads"
# rm $BUILDDIR/$SOURCE/part2/n2fitting/*.mat
# rm $BUILDDIR/$SOURCE/part2/n2fitting/*.out

echo "*** Building $BUILDENV"
jupyter-book build $BUILDDIR/$SOURCE/

echo "*** Copying $BUILDDIR/$SOURCE/_build/$BUILDENV to $REFDIR"
mkdir -p $REFDIR
cp $BUILDDIR/$SOURCE/_build/$BUILDENV/* -r $REFDIR

unset BUILDENV

# *** Build PDF
export BUILDENV=pdf
BUILDDIR=$BUILDSOURCE/$BUILDENV
REFDIRHTML=$REFDIR
REFDIR="$BUILDSOURCE/$BUILDENV-build"

#*** Make new copy to allow re-execution with pdf env set.
echo "*** Copying source files from doc-source to $BUILDDIR"
if [ -d "$BUILDDIR" ]; then rm -Rf $BUILDDIR; fi
mkdir -p $BUILDDIR
# COPY only required files - easy to miss stuff here
# cp doc-source/* --parents $BUILDSOURCE
# cp doc-source/**/*.ipynb --parents $BUILDSOURCE
# COPY full dir, then remove .md
cp $SOURCE/ -r $BUILDDIR
rm -r $BUILDDIR/$SOURCE/_build   # Ensure clean build, having issues otherwise...?
# echo Removing .md from subdirs using $BUILDSOURCE/doc-source/**/*.md 
# rm $BUILDSOURCE/doc-source/**/*.md

# Clean - should set as option
echo "*** Cleaning $BUILDDIR"
jupyter-book clean $BUILDDIR/$SOURCE/

# 24/10/23 - added set intro pages here
echo "*** Setting intro to intro_pdf.md"
ln -s -f $BUILDDIR/$SOURCE/intro_pdf.md $BUILDDIR/$SOURCE/intro.md

# 24/10/23 - script injection to fix Mathjax in pages without maths
# echo "*** Removing Mathjax..."
# for originalFile in "${filesScript[@]}"
# do
#     rm $BUILDDIR/$SOURCE/$originalFile
#     cp $BUILDDIR/$SOURCE/$originalFile.noscript $BUILDDIR/$SOURCE/$originalFile
# done


echo "*** Building $BUILDENV"
# jupyter-book build $BUILDDIR/$SOURCE/

# PDF build and skip errors - run x3 to ensure refs etc.
# TODO: this is rubbish, need multiple runs for cross-refs, but currently ALSO RUNNING NBs each time NEED TO FIX.
jupyter-book build --keep-going $BUILDDIR/$SOURCE/ --builder pdflatex
jupyter-book build --keep-going $BUILDDIR/$SOURCE/ --builder pdflatex
jupyter-book build --keep-going $BUILDDIR/$SOURCE/ --builder pdflatex

# Debug for missing refs. as Warnings - note this should also keep going, but doesn't and may get no PDF
# See https://jupyterbook.org/en/stable/basics/build.html#debug-your-books-build-process
# jupyter-book build -W -n --keep-going doc-source/ --builder pdflatex

echo "*** Copying $BUILDDIR/$SOURCE/_build/latex to $REFDIR"
mkdir -p $REFDIR
cp $BUILDDIR/$SOURCE/_build/latex/* -r $REFDIR

echo "*** Copying $BUILDDIR/$SOURCE/_build/latex/*.pdf to $REFDIRHTML/pdf"
mkdir -p $REFDIRHTML/pdf
cp $BUILDDIR/$SOURCE/_build/latex/QM3.pdf $REFDIRHTML/pdf


unset BUILDENV

# *** Backup build

# Copy to datestamp tmp dir, from https://stackoverflow.com/questions/33996226/copy-and-create-a-directory-with-date-timestamp-where-it-does-not-exist
# mkdir -p "$TMPDIR/$(date +%Y-%m-%d-%H:%M:%S)" && cp -a "$TMPDIR/_latest_build" "$_"   # Should work directly...?

DATEDIR=$TMPDIR/$(date +%Y-%m-%d_%H-%M-%S)
echo "*** Build dir copy to $DATEDIR"
mkdir -p "$DATEDIR"
cp -a $TMPDIR/_latest_build/* $DATEDIR


# Copy also to main _latest_build dir...?
echo "*** HTML build dir copy to $BASEPATH/_latest_build"
cp -a $TMPDIR/_latest_build/html-build $BASEPATH/_latest_build

# Copy source too - use this dir for full GH pages deploy
echo "*** Latex build dir to $BASEPATH/_latest_build/latex"
# cp -a $BUILDDIR/$SOURCE/_build/latex $REFDIRHTML
cp -a $TMPDIR/_latest_build/pdf-build $BASEPATH/_latest_build/html-build


echo "TODO: tidy up and config GH actions for deploy from this dir."
echo "TODO: Output logs to file."
echo "***   To deploy manually, run '$BASEPATH/scripts/deploy_ghpages-latest-tmp.sh .' from repo root."



