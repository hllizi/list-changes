# List changes in git repository

Bash scripts to 

  * provide as list of all changed files in a git repository, including those changed in submodules, but excluding the submodules (changed.sh)
  * obtain the currently checked out commits of all project modules (save_commits.sh)

This is useful in order to copy only the minimal amount of files when creating an updated container image that includes the repository.
