# bigdata-stuff
Collection of scripts / tools / code and stuff

PYTHON_VERSION="$(python -V 2>&1)"
if [[ $PYTHON_VERSION == "Python 3"* ]]; then
  echo "Python 3"
fi


 .profile


case $- in
  *i*)
    # Interactive session. Try switching to bash.
    if [ -z "$BASH" ]; then # do nothing if running under bash already
      bash=$(command -v bash)
      if [ -x "$bash" ]; then
        export SHELL="$bash"
        exec "$bash"
      fi
    fi
esac

