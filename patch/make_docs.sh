#!/bin/sh

patch < <(cat <<'EOF'
diff --git a/tools/make_docs.sh b/tools/make_docs.sh
index c6e7c44..7d42f2c 100755
--- a/tools/make_docs.sh
+++ b/tools/make_docs.sh
@@ -7,6 +7,10 @@ cd ../java

 export OUT_PATH="../out/docs"

-javadoc -Xdoclint:none -windowtitle "CEF3 Java API Docs" -footer "<center><a href="https://bitbucket.org/chromiumembedded/java-cef" target="_top">Chromium Embedded Framework (CEF)</a> Copyright &copy 2013 Marshall A. Greenblatt</center>" -nodeprecated -d $OUT_PATH -link http://docs.oracle.com/javase/7/docs/api/ -subpackages org.cef
+javadoc -Xdoclint:none -windowtitle "CEF3 Java API Docs" \
+-footer "<center><a href="https://bitbucket.org/chromiumembedded/java-cef" target="_top">Chromium Embedded Framework (CEF)</a> Copyright &copy $(date '+%Y') Marshall A. Greenblatt</center>" \
+-nodeprecated -d $OUT_PATH -link 'https://docs.oracle.com/javase/8/docs/api/' \
+-subpackages org.cef \
+-classpath .:../third_party/jogamp/jar/*

 cd ../tools

EOF
) "$1/tools/make_docs.sh"

cat "$1/tools/make_docs.sh"
