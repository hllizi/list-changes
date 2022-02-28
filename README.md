# List changes in git repository

Bash scripts to 

  * provide as list of all changed files in a git repository, including those changed in submodules, but excluding the submodules (changed.sh)
  * obtain the currently checked out commits of all project modules (save_commits.sh)

This is useful in order to copy only the minimal amount of files when creating an updated container image that includes the repository.

## USAGE:

called in a git repository, save_commits.sh outputs a list with entries of the shape

<module-path>//<commit-hash> 

This list contains for ever submodule and the main module the commit at which the moddule currently is.

changed.sh accepts as input a list of the kind that is the output of save_commits.sh.The output is a list of all files in all modules which are different in the current state of the repository from the state in the commit hash the module is assigned in the list.

If provided with the option -c, changed.sh does not read from STDIN and outpus the list of all files with uncommitted changes.

## Limitations

The script cannot yet deal with recursive submodules if used with a list of commit hashes. Determining files changed but not yet commited with option -c should work.
