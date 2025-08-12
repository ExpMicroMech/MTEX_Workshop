This small repository provides people with some example data, and loading scripts, for getting EBSD data into MTEX.

We have a few loaders / examples:

Example_Deck - this will load a single phase h5oina file and plot some of the data.
               You can see how this works via the https://github.com/ExpMicroMech/MTEX_Workshop/tree/main/PublishedFiles/Example_Deck.pdf

Example_Deck_OI_TwoPhase - this will load a data set containing two phases using h5oina data.

Example_Deck_TSL - this will load a TSL data set that has been exported as an ang file

Example_Deck_TFS - this will load data collected using xTalview (collected on an Apreo 2 ChemiSEM with TruePix)


Users are recommended to try to run each of the decks, in the order above, as and run them 'section by section' to see what is going on and what you can do. The MTEX example pieces in each should provide you a rich tool set to analyze EBSD data, and you can build you future analysis pipeline from a mixture of these (and the entire MTEX toolbox).

You are recommended to have MTEX 5.11.2 (or there abouts) to reduces errors, and also they work with Matlab 2023a onwards. You can get MTEX here: https://mtex-toolbox.github.io/download

They probably work better on windows installs (due to changes in how mac uses the '\' vs '/' character for file loading).

The loaders are provided 'as is' - we have done some work to check they work against the conventions/tests as set out in the "Which way is up?" paper.
T.B. Britton, J. Jiang, Y. Guo, A. Vilalta-Clemente, D. Wallis, L. Hansen, A. Winkelmann, A.J. Wilkinson Tutorial: Crystal orientations and EBSD — Or which way is up? Materials Characterization (2016) http://dx.doi.org/10.1016/j.matchar.2016.04.008 and https://spiral.imperial.ac.uk/handle/10044/1/31250,

Contributions to these loaders include:

Ben Britton, Ruth Birch, Shuheng Li, Tianbi Zhang, Simon Wyatt (and probably others from ExpMicroMech).
www.expmicromech.com

If you are more interested in pattern analysis, rather than map analysis, you may find the AstroEBSD toolbox also helpful: https://github.com/ExpMicroMech/AstroEBSD

Note: Scripts are provided 'as is' and you should check that they work properly on your system, for your data. We have no responsibility for what you do with this code.

(Readme written by Ben Britton, 2025-08-12)
