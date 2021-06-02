git clone https://github.com/chromiumembedded/java-cef.git $JCEF_DIR
./apply-patches.sh $JCEF_DIR

# jdk stuff taken care of in docker image
if [ ! -z "$ARCH_DIST" ] && [ $ARCH_DIST != 'linux32' ]; then
  source ./setup-jdk.sh
fi
