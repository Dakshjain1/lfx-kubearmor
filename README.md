# lfx-kubearmor

TASKS -

DONE
* pull request to run on only policy files, not on readme updates - resolved by triggering action only on issue comment
* issue comment trigger only when comment match - done


TODO
* fetch the files changed to get the folder name to make action modular - then rename all postgres to {{ folder name}} in action
* instead of rm -rf ./postgres/README.md remove top 5 lines from the file - suggest better way
* add status checks pending on start  +  done at end.
    * if job cancelled - change status to failure - in readme it should be only fail or success


* 5 policies - nginx-ingress controller
