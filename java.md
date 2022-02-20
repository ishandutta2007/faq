#### Java

##### Downloading JDK without login

Use link provided when trying to get it from web page

    https://download.oracle.com/otn/java/jdk/8u291-b10/d7fc238d0cbf4b0dac67be84580cfb4b/jdk-8u291-linux-x64.tar.gz

And modify it a bit and use cookie

    wget --header='Cookie: oraclelicense=accept-securebackup-cookie' \
     https://download.oracle.com/otn-pub/java/jdk/8u291-b10/d7fc238d0cbf4b0dac67be84580cfb4b/jdk-8u291-linux-x64.tar.gz

Automated way:

    export latestJdk8=$(curl -s https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html | grep 'linux-x64.tar.gz' | sed "s/' data-license.*//;s/.*data-file='//;s/otn/otn-pub/")
    wget --header='Cookie: oraclelicense=accept-securebackup-cookie' "${latestJdk8}"

##### Listing jar content

Jar

    jar tf some-lib.jar

##### Decompiling classes

GUI:

    java -jar jd-gui-1.4.0.jar

Command line:

    ./jad HelloWorld.class
    java -jar procyon-decompiler-0.5.30.jar com.samples.HelloWorld


##### GC logs

Enable logging JVM 8

    -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintGCCause -Xloggc:/tmp/java8.gc.log

Enable logging JVM 11

    -Xlog:gc=debug:file=/tmp/java11.gc.log:utctime,uptime,level -XX:NativeMemoryTracking=summary 

##### Regular expressions

Test java/regular expression before use: http://www.regexplanet.com/advanced/java/index.html

Pattern flags

 * Pattern.CASE_INSENSITIVE - enables case-insensitive matching.
 * Pattern.COMMENTS - whitespace and comments starting with # are ignored until the end of a line.
 * Pattern.MULTILINE - one expression can match multiple lines.
 * Pattern.UNIX_LINES - only the '\n' line terminator is recognized in the behavior of ., ^, and $.

Useful Java classes & methods

PATTERN
A pattern is a compiler representation of a regular expression.

 * `Pattern compile(String regex)` : Compiles the given regular expression into a pattern.
 * `Pattern compile(String regex, int flags)` : Compiles the given regular expression into a pattern with the given flags.
 * `boolean matches(String regex)` : Tells whether or not this string matches the given regular expression.
 * `String[] split(CharSequence input)` : Splits the given input sequence around matches of this pattern.
 * `String quote(String s)` : Returns a literal pattern String for the specified String.
 * `Predicate<String> asPredicate()` : Creates a predicate which can be used to match a string.

MATCHER
An engine that performs match operations on a character sequence by interpreting a Pattern.

 * `boolean matches()` : Attempts to match the entire region against the pattern.
 * `boolean find()` : Attempts to find the next subsequence of the input sequence that matches the pattern.
 * `int start()` : Returns the start index of the previous match.
 * `int end()` : Returns the offset after the last character matched.

Characters

 * \d : Most engines: one digit : from 0 to 9 `file_\d\d ` : `file_25`
 * \d : .NET, Python 3: one Unicode digit in any script : `file_\d\d` : `file_9੩`
 * \w : Most engines: "word character": ASCII letter, digit or underscore : `\w-\w\w\w` : `A-b_1`
 * \w : .Python 3: "word character": Unicode letter, ideogram, digit, or underscore : `\w-\w\w\w` : `字-ま_۳`
 * \w : .NET: "word character": Unicode letter, ideogram, digit, or connector : `\w-\w\w\w` : `字-ま‿۳`
 * \s : Most engines: "whitespace character": space, tab, newline, carriage return, vertical tab : `a\sb\sc` : `a b c`
 * \s : .NET, Python 3, JavaScript: "whitespace character": any Unicode separator : `a\sb\sc` : `a b c`
 * \D : One character that is not a digit as defined by your engine's \d : `\D\D\D` : `ABC`
 * \W : One character that is not a word character as defined by your engine's \w : `\W\W\W\W\W` : `*-+=)`
 * \S : One character that is not a whitespace character as defined by your engine's \s : `\S\S\S\S` : `Yoyo`

Quantifiers

 * + : One or more : `Version \w-\w+` : `Version A-b1_1`
 * {3} : Exactly three times : `\D{3}` : `ABC`
 * {2,4} : Two to four times : `\d{2,4}` : `156`
 * {3,} : Three or more times : `\w{3,}` : `regex_tutorial`
 * * : Zero or more times : `A*B*C*` : `AAACC`
 * ? : Once or none : `plurals?` : `plural`

More Characters

 * . : Any character except line break : `a.c` : `abc`
 * . : Any character except line break : `.*` : `whatever, man.`
 * \. : A period (special character: needs to be escaped by a \) : `a\.c` : `a.c`
 * \ : Escapes a special character : `\.\*\+\?    \$\^\/\\` : `.*+?    $^/\`
 * \ : Escapes a special character : `\[\{\(\)\}\]` : `[{()}]`

Logic

 * | : Alternation / OR operand : `22|33` : `33`
 * ( … ) : Capturing group : `A(nt|pple)` : `Apple (captures "pple")`
 * \1 : Contents of Group 1 : `r(\w)g\1x` : `regex`
 * \2 : Contents of Group 2 : `(\d\d)\+(\d\d)=\2\+\1` : `12+65=65+12`
 * (?: … ) : Non-capturing group : `A(?:nt|pple)` : `Apple`

More White-Space

 * \t : Tab : `T\t\w{2}` : `T     ab`
 * \r : Carriage return character : `see below` : ``
 * \n : Line feed character : `see below` : ``
 * \r\n : Line separator on Windows : `AB\r\nCD` : `AB\nCD`
 * \N : Perl, PCRE (C, PHP, R…): one character that is not a line break : `\N+` : `ABC`
 * \h : Perl, PCRE (C, PHP, R…), Java: one horizontal whitespace character: tab or Unicode space separator
 * \H : One character that is not a horizontal whitespace
 * \v : .NET, JavaScript, Python, Ruby: vertical tab
 * \v : Perl, PCRE (C, PHP, R…), Java: one vertical whitespace character: line feed, carriage return, vertical tab, form feed, paragraph or line separator
 * \V : Perl, PCRE (C, PHP, R…), Java: any character that is not a vertical whitespace
 * \R : Perl, PCRE (C, PHP, R…), Java: one line break (carriage return + line feed pair, and all the characters matched by \v)

More Quantifiers

 * + : The + (one or more) is "greedy" : `\d+` : `12345`
 * ? : Makes quantifiers "lazy" : `\d+?` : `1 in 12345`
 * * : The * (zero or more) is "greedy" : `A*` : `AAA`
 * ? : Makes quantifiers "lazy" : `A*?` : `empty in AAA`
 * {2,4} : Two to four times, "greedy" : `\w{2,4}` : `abcd`
 * ? : Makes quantifiers "lazy" : `\w{2,4}?` : `ab in abcd`

Character Classes

 * [ … ] : One of the characters in the brackets : `[AEIOU]` : One uppercase vowel
 * [ … ] : One of the characters in the brackets : `T[ao]p` : `Tap or Top`
 * - : Range indicator : `[a-z]` : One lowercase letter
 * [x-y] : One of the characters in the range from x to y : `[A-Z]+` : `GREAT`
 * [ … ] : One of the characters in the brackets : `[AB1-5w-z]` : One of either: A,B,1,2,3,4,5,w,x,y,z
 * [x-y] : One of the characters in the range from x to y : `[ -~]+` : Characters in the printable section of the ASCII table.
 * [^x] : One character that is not x : `[^a-z]{3}` : `A1!`
 * [^x-y] : One of the characters not in the range from x to y : `[^ -~]+` : Characters that are not in the printable section of the ASCII table.
 * [\d\D] : One character that is a digit or a non-digit : `[\d\D]+` : Any characters, including new lines, which the regular dot doesn't match
 * [\x41] : Matches the character at hexadecimal position 41 in the ASCII table, i.e. A : `[\x41-\x45]{3}` : `ABE`

Anchors and Boundaries

 * ^ : Start of string or start of linedepending on multiline mode. (But when [^inside brackets], it means "not") * abc .*	abc (line start)
 * $ : End of string or end of linedepending on multiline mode. Many engine-dependent subtleties. * *? the end$	this is the end
 * \A : Beginning of string (all major engines except JS) * Aabc[\d\D]*	abc (string start...
 * \z : Very end of the string (not available in Python and JS) * he end\z	this is...\n...the end
 * \Z : End of string or (except Python) before final line break (not available in JS) * he end\Z	this is...\n...the end\n
 * \G : Beginning of String or End of Previous Match (.NET, Java, PCRE (C, PHP, R…), Perl, Ruby)
 * \b : Word boundary (most engines: position where one side only is an ASCII letter, digit or underscore) * ob.*\bcat\b	Bob ate the cat
 * \b : Word boundary (.NET, Java, Python 3, Ruby: position where one side only is a Unicode letter, digit or underscore) * ob.*\b\кошка\b	Bob ate the кошка
 * \B : Not a word boundary * .*\Bcat\B.*	copycats

POSIX Classes

 * [:alpha:] : PCRE (C, PHP, R…): ASCII letters A-Z and a-z : `[8[:alpha:]]+` : `WellDone88`
 * [:alpha:] : Ruby 2: Unicode letter or ideogram : `[[:alpha:]\d]+` : `кошка99`
 * [:alnum:] : PCRE (C, PHP, R…): ASCII digits and letters A-Z and a-z : `[[:alnum:]]{10}` : `ABCDE12345`
 * [:alnum:] : Ruby 2: Unicode digit, letter or ideogram : `[[:alnum:]]{10}` : `кошка90210`
 * [:punct:] : PCRE (C, PHP, R…): ASCII punctuation mark : `[[:punct:]]+` : `?!.,:;`
 * [:punct:] : Ruby: Unicode punctuation mark : `[[:punct:]]+` : `‽,:〽⁆`

Inline Modifiers
None of these are supported in JavaScript. In Ruby, beware of (?s) and (?m). 

 * (?i) : Case-insensitive mode (except JavaScript) : `(?i)Monday` : `monDAY`
 * (?s) : DOTALL mode (except JS and Ruby). The dot (.) matches new line characters (\r\n). Also known as "single-line mode" because the dot treats the entire input as a single line : `(?s)From A.*to Z` : `From A\r\nto Z`
 * (?m) : Multiline mode (except Ruby and JS) ^ and $ match at the beginning and end of every line) : `(?m)1\r\n^2$\r\n^3$` : `1\r\n2\r\n3`
 * (?m) : In Ruby: the same as (?s) in other engines, i.e. DOTALL mode, i.e. dot matches line breaks : `(?m)From A.*to Z` : `From A\r\ntoZ`
 * (?x) : Free-Spacing Mode mode (except JavaScript). Also known as comment mode or whitespace mode
 * (?n) : .NET: named capture only : `Turns all (parentheses) into non-capture groups. To capture, use named groups.` : ``
 * (?d) : Java: Unix linebreaks only : `The dot and the ^ and $ anchors are only affected by \n` : ``

Lookarounds

 * (?=…) : Positive lookahead : `(?=\d{10})\d{5}` : `01234 in 0123456789`
 * (?<=…) : Positive lookbehind : `(?<=\d)cat` : `cat in 1cat`
 * (?!…) : Negative lookahead : `(?!theatre)the\w+` : `theme`
 * (?<!…) : Negative lookbehind : `\w{3}(?<!mon)ster` : `Munster`

Character Class Operations

 * […-[…]] : .NET: character class subtraction. One character that is in those on the left, but not in the subtracted class. : `[a-z-[aeiou]]` : Any lowercase consonant
 * […-[…]] : .NET: character class subtraction. : `[\p{IsArabic}-[\D]]` : An Arabic character that is not a non-digit, i.e., an Arabic digit
 * […&&[…]] : Java, Ruby 2+: character class intersection. One character that is both in those on the left and in the && class. : `[\S&&[\D]]` : An non-whitespace character that is a non-digit.
 * […&&[…]] : Java, Ruby 2+: character class intersection. : `[\S&&[\D]&&[^a-zA-Z]]` : An non-whitespace character that a non-digit and not a letter.
 * […&&[^…]] : Java, Ruby 2+: character class subtraction is obtained by intersecting a class with a negated class : `[a-z&&[^aeiou]]` : An English lowercase letter that is not a vowel.
 * […&&[^…]] : Java, Ruby 2+: character class subtraction : `[\p{InArabic}&&[^\p{L}\p{N}]]` : An Arabic character that is not a letter or a number

Other Syntax

 * \K : Keep Out, Perl, PCRE (C, PHP, R…), Python's alternate regexengine, Ruby 2+: drop everything that was matched so far from the overall match to be returned : `prefix\K\d+` : `12`
 * \Q…\E : Perl, PCRE (C, PHP, R…), Java: treat anything between the delimiters as a literal string. Useful to escape metacharacters. : `\Q(C++ ?)\E` : `(C++ ?)`

##### Heap dump analaysis

Heap dump analyais with MAT - search for a leak

MAT: https://www.eclipse.org/mat/downloads.php


    # get javaDir
    source ${HOME}/env/current.cfg
    
    echo ''
    date +'%F %T'
    
    test -f "$1" || { echo "can't read file [$1], or not argument given to the command, exiting"; exit; }
    
    echo "Using heap dump: [$1]"
    heapDumpFile="$(readlink -f $1)"
    heapDumpDir="$(dirname ${heapDumpFile})"
    
    matDir="/tools/java/MAT/latest"
    matJar=$(ls -1 ${matDir}/plugins/org.eclipse.equinox.launcher_*.jar)
    
    test -d "${matDir}" || { echo "no MAT jar in dir [${matDir}], exiting"; exit; }
    
    ${javaDir}/bin/java -jar ${matJar} \
      -consoleLog \
      -application org.eclipse.mat.api.parse ${heapDumpFile} \
      -data $(dirname ${heapDumpFile})/workspace-${USER}
      org.eclipse.mat.api:suspects
    
    echo "Cleaning MAT files ..."
    rm -rf workspace-${USER}
    for matFile in $(find ${heapDumpDir} -iname '*.index' -o -iname '*.threads') ; do
      echo " removing $(basename ${matFile})"
      rm ${matFile}
    done
    echo "Cleaning completed."

To change default workspace location use: `-data your_workspace_location`
The `org.eclipse.mat.api:suspects argument` creates a ZIP file containing the leak suspect report. This argument is optional.
The `org.eclipse.mat.api:overview argument` creates a ZIP file containing the overview report. This argument is optional.
The `org.eclipse.mat.api:top_components` argument creates a ZIP file containing the top components report. This argument is optional.

[Reference](https://wiki.eclipse.org/MemoryAnalyzer/FAQ)


Heap dump analysis with IBM heap analyzer

Get jar file from http://public.dhe.ibm.com/software/websphere/appserv/support/tools/HeapAnalyzer/ha456.jar

    java -jar ha456.jar

Open heap dump file, you will get some basic analysis done


##### Core dump anlaysis

Core dump creation

    gcore
    crash
    kill -6
    gdb -core=/path/to/file.core

Core dump basics

Generating a Java Core Dump

Create class code

    echo '
    /**
     * A class to demonstrate core dumping.
     */
    public class CoreDumper {
     // load the library
     static {
      System.loadLibrary("nativelib");
     }
     // native method declaration
     public native void core();
     public static void main(String[] args) {
      new CoreDumper().core();
     }
    }' > CoreDumper.java
      
Compile

    javac CoreDumper.java
    ls
    # CoreDumper.class  CoreDumper.java
 
Generate the header file

    $ javah -jni CoreDumper
    $ ls
    #CoreDumper.class  CoreDumper.h  CoreDumper.java
 
Implement the native method
Copy the method declaration from the header file and create a new file containing the implementation of this method:
      
    echo '
    #include "CoreDumper.h"
    void bar() {
      // the following statements will produce a core
      int* p = NULL;
      *p = 5;
     
      // alternatively:
      // abort();
    }
    void foo() {
      bar();
    }
    JNIEXPORT void JNICALL Java_CoreDumper_core
      (JNIEnv *env, jobject obj) {
      foo();
    }' > CoreDumper.c
    
Compile

    gcc -fPIC -o libnativelib.so -shared \
              -I$JAVA_HOME/include/linux/ \
              -I$JAVA_HOME/include/ \
               CoreDumper.c
    ls
    #CoreDumper.class  CoreDumper.h  CoreDumper.java libnativelib.so

Run

    java -Djava.library.path=. CoreDumper
    ##
    ## A fatal error has been detected by the Java Runtime Environment:
    ##
    ##  SIGSEGV (0xb) at pc=0x0000002b1cecf75c, pid=18919, tid=1076017504
    ##
    ## JRE version: 6.0_21-b06
    ## Java VM: Java HotSpot(TM) 64-Bit Server VM (17.0-b16 mixed mode linux-amd64 )
    ## Problematic frame:
    ## C  [libnativelib.so+0x75c]  bar+0x10
    ##
    ## An error report file with more information is saved as:
    ## /home/sharfah/tmp/jni/hs_err_pid18919.log
    ##
    ## If you would like to submit a bug report, please visit:
    ##   http://java.sun.com/webapps/bugreport/crash.jsp
    ## The crash happened outside the Java Virtual Machine in native code.
    ## See problematic frame for where to report the bug.
    ##
    #Aborted (core dumped)

Running the program causes its crash and a core file is produced (e.g /var/tmp/cores)
To see what your core file directory is configured to run `cat /proc/sys/kernel/core_pattern`
    ls /var/tmp/cores
    #java.21178.146385.core

[Resource](http://fahdshariff.blogspot.com/2012/08/generating-java-core-dump.html)

Issues based files

 * hs_err_pid log file. JMV produces an error log file called hs_err_pidXXXX.log, normally in the working directory of the process or in the temporary directory for the operating system.
   The top of this file contains the cause of the crash and the "problematic frame".

       head hs_err_pid21178.log
       #
       # A fatal error has been detected by the Java Runtime Environment:
       #
       #  SIGSEGV (0xb) at pc=0x0000002b1d00075c, pid=21178, tid=1076017504
       #
       # JRE version: 6.0_21-b06
       # Java VM: Java HotSpot(TM) 64-Bit Server VM (17.0-b16 mixed mode linux-amd64 )
       # Problematic frame:
       # C  [libnativelib.so+0x75c]  bar+0x10

   There is also a stack trace:

       Stack: [0x000000004012b000,0x000000004022c000],  sp=0x000000004022aac0,  free space=3fe0000000000000018k
       Native frames: (J=compiled Java code, j=interpreted, Vv=VM code, C=native code)
       C  [libnativelib.so+0x75c]  bar+0x10
       C  [libnativelib.so+0x772]  foo+0xe
       C  [libnativelib.so+0x78e]  Java_CoreDumper_core+0x1a
       j  CoreDumper.core()V+0
       j  CoreDumper.main([Ljava/lang/String;)V+7
       v  ~StubRoutines::call_stub
       V  [libjvm.so+0x3e756d]

    It shows that java method, CoreDumper.core(), was called into JNI and died when the bar function was called in native code.

 * core files. In some cases, the JVM may not produce a hs_err_pid file, for example, if the native code abruptly aborts by calling the abort function.
   In such cases, we need to analyse the core file produced. 

Java Core Dump analysis

 * gdb
   GNU Debugger (gdb) can examine a core file and work out what the program was doing when it crashed.

       gdb $JAVA_HOME/bin/java /var/tmp/cores/java.14015.146385.core
       (gdb) where
       #0  0x0000002a959bd26d in raise () from /lib64/tls/libc.so.6
       #1  0x0000002a959bea6e in abort () from /lib64/tls/libc.so.6
       #2  0x0000002b1cecf799 in bar () from libnativelib.so
       #3  0x0000002b1cecf7a7 in foo () from libnativelib.so
       #4  0x0000002b1cecf7c3 in Java_CoreDumper_core () from libnativelib.so
       #5  0x0000002a971aac88 in ?? ()
       #6  0x0000000040113800 in ?? ()
       #7  0x0000002a9719fa42 in ?? ()
       #8  0x000000004022ab10 in ?? ()
       #9  0x0000002a9a4d5488 in ?? ()
       #10 0x000000004022ab70 in ?? ()
       #11 0x0000002a9a4d59c8 in ?? ()
       #12 0x0000000000000000 in ?? ()

   The where command prints the stack frames and shows that the bar function called abort() which caused the crash.

 * jstack
   jstack prints stack traces of Java threads for a given core file.

       $ jstack -J-d64 $JAVA_HOME/bin/java /var/tmp/cores/java.14015.146385.core
       Debugger attached successfully.
       Server compiler detected.
       JVM version is 17.0-b16
       Deadlock Detection:
       No deadlocks found.
       Thread 16788: (state = BLOCKED)
       Thread 16787: (state = BLOCKED)
        - java.lang.Object.wait(long) @bci=0 (Interpreted frame)
        - java.lang.ref.ReferenceQueue.remove(long) @bci=44, line=118 (Interpreted frame)
        - java.lang.ref.ReferenceQueue.remove() @bci=2, line=134 (Interpreted frame)
        - java.lang.ref.Finalizer$FinalizerThread.run() @bci=3, line=159 (Interpreted frame)
       Thread 16786: (state = BLOCKED)
        - java.lang.Object.wait(long) @bci=0 (Interpreted frame)
        - java.lang.Object.wait() @bci=2, line=485 (Interpreted frame)
        - java.lang.ref.Reference$ReferenceHandler.run() @bci=46, line=116 (Interpreted frame)
       Thread 16780: (state = IN_NATIVE)
        - CoreDumper.core() @bci=0 (Interpreted frame)
        - CoreDumper.main(java.lang.String[]) @bci=7, line=12 (Interpreted frame)

   Simplified perspective for interpreting thread dumps (based on [link](https://stackoverflow.com/questions/15680422/difference-between-wait-and-blocked-thread-states)):

    * WAIT - I'm waiting to be given some work, so I'm idle right now.
    * BLOCKED - I'm busy trying to get work done but another thread is standing in my way, so I'm idle right now.
    * RUNNABLE...(Native Method) - I called out to RUN some native code (which hasn't finished yet) so as far as the JVM is concerned, you're RUNNABLE and it can't give any further information.
      A common example would be a native socket listener method coded in C which is actually waiting for any traffic to arrive, so I'm idle right now.
      In that situation, this is can be seen as a special kind of WAIT as we're not actually RUNNING (no CPU burn) at all but you'd have to use an OS thread dump rather than a Java thread dump to see it.
   

 * jmap
   jmap examines a core file and prints out shared object memory maps or heap memory details.

       $ jmap -J-d64 $JAVA_HOME/bin/java /var/tmp/cores/java.14015.146385.core
       Debugger attached successfully.
       Server compiler detected.
       JVM version is 17.0-b16
       0x0000000040000000      49K     /usr/sunjdk/1.6.0_21/bin/java
       0x0000002a9566c000      124K    /lib64/tls/libpthread.so.0
       0x0000002a95782000      47K     /usr/sunjdk/1.6.0_21/jre/lib/amd64/jli/libjli.so
       0x0000002a9588c000      16K     /lib64/libdl.so.2
       0x0000002a9598f000      1593K   /lib64/tls/libc.so.6
       0x0000002a95556000      110K    /lib64/ld-linux-x86-64.so.2
       0x0000002a95bca000      11443K  /usr/sunjdk/1.6.0_21/jre/lib/amd64/server/libjvm.so
       0x0000002a96699000      625K    /lib64/tls/libm.so.6
       0x0000002a9681f000      56K     /lib64/tls/librt.so.1
       0x0000002a96939000      65K     /usr/sunjdk/1.6.0_21/jre/lib/amd64/libverify.so
       0x0000002a96a48000      228K    /usr/sunjdk/1.6.0_21/jre/lib/amd64/libjava.so
       0x0000002a96b9e000      109K    /lib64/libnsl.so.1
       0x0000002a96cb6000      54K     /usr/sunjdk/1.6.0_21/jre/lib/amd64/native_threads/libhpi.so
       0x0000002a96de8000      57K     /lib64/libnss_files.so.2
       0x0000002a96ef4000      551K    /lib64/libnss_db.so.2
       0x0000002a97086000      89K     /usr/sunjdk/1.6.0_21/jre/lib/amd64/libzip.so
       0x0000002b1cecf000      6K      /home/sharfah/tmp/jni/libnativelib.so

[Resource](http://fahdshariff.blogspot.co.uk/2012/08/analysing-java-core-dump.html)


Core dump analysis (command line)

Validate core dump:

    file jvm.core
    jvm.core: ELF 64-bit LSB core file x86-64, version 1 (SYSV), SVR4-style, from '/opt/java/jdk1.8.0_31/bin/java -Dnop -Djava.util.logging.manager=org.apache'
    
    objdump -a core  
    core:     file format elf64-x86-64  
    Core  
    
    readelf -a core 2>&1 | grep -i warn | wc -l
    0  

Analyze the core

    java_bin='/opt/java/Linux_x86_64_64bit/jdk1.8.0_131/bin/java'
    java_core='input_data/core.11651'
    
    jdb -connect sun.jvm.hotspot.jdi.SACoreAttachingConnector:\javaExecutable="${java_bin}",core="${java_core}"
    
    jinfo "${java_bin}" "${java_core}"
    
    jmap "${java_bin}" "${java_core}"
    jmap -heap "${java_bin}" "${java_core}"
    jmap -histo "${java_bin}" "${java_core}"
    
    jstack -l "${java_bin}" "${java_core}"

Core dump anlaysis (gui)

Get jar file from http://public.dhe.ibm.com/software/websphere/appserv/support/tools/jca/jca457.jar

    java -jar jca457.jar

Open core dump file, you will get some basic analysis done


##### Using flame graphs

preparation

    sudo yum install -y perf cmake
    cd $HOME
    mkdir perf-flame-graphs
    cd perf-flame-graphs
    git clone https://github.com/brendangregg/FlameGraph
    git clone https://github.com/jvm-profiling-tools/perf-map-agent, 
    cd perf-map-agent
    export JAVA_HOME=/opt/java/x86-GNU_Linux_64bit/jdk1.8.0_151
    cmake .
    make
    
usage

    # run process with required parameter
    java -XX:+PreserveFramePointer ...
    # recording for everything
    sudo perf record -F 99 -a -g -- sleep 30
    # .. or recording for java process pid $PID
    PID=`ps -ef | grep -v grep | grep java | grep ^$USER | awk '{print $2}'`
    java -cp attach-main.jar:$JAVA_HOME/lib/tools.jar net.virtualvoid.perf.AttachOnce $PID # run as same user as java
    
analysis

    sudo chown root /tmp/perf-*.map
    sudo perf script | stackcollapse-perf.pl | flamegraph.pl --color=java --hash > flamegraph.svg

##### Using flight recorder

References:
 * https://docs.oracle.com/javacomponents/jmc-5-4/jfr-runtime-guide/run.htm#JFRUH178> 
 * https://docs.oracle.com/javacomponents/jmc-5-4/jfr-runtime-guide/comline.htm#JFRUH197


You need at least version 7u4 to run JFR at all.

To work with flight rcorded following options should be added: `-XX:+UnlockCommercialFeatures -XX:+FlightRecorder`

Basic commands:
 * `JFR.start` : Start a recording.
 * `JFR.check` : Check the status of all recordings running for the specified process, including the recording identification number, file name, duration, and so on.
 * `JFR.stop` : Stop a recording with a specific identification number (by default, recording 1 is stopped).
 * `JFR.dump` : Dump the data collected so far by the recording with a specific identification number (by default, data from recording 1 is dumped).

JFR.start

| Parameter | Description | Type of value | Default |
|-----------|-------------|---------------|---------|
| name | Name of recording | String |   |
| settings | Server-side template | String |   |
| defaultrecording | Starts default recording | Boolean | False |
| delay | Delay start of recording | Time | 0s |
| duration | Duration of recording | Time | 0s (means "forever") |
| filename | Resulting recording filename | String |   |
| compress | GZip compress the resulting recording file | Boolean | False |
| maxage | Maximum age of buffer data | Time | 0s (means "no age limit") |
| maxsize | Maximum size of buffers in bytes | Long | 0 (means "no max size") |

JFR.check

| Parameter | Description | Type of value | Default |
|-----------|-------------|---------------|---------|
| recording | Recording id | Long | 1 |
| verbose | Print verbose data | Boolean | False |

JFR.stop

| Parameter | Description | Type of value | Default |
|-----------|-------------|---------------|---------|
| recording | Recording id | Long | 1 |
| discard | Discards the recording data | Boolean |   |
| copy_to_file | Copy recording data to file | String |   |
| compress_copy | GZip compress "copy_to_file" destination | Boolean | False |

JFR.dump

| Parameter | Description | Type of value | Default |
|-----------|-------------|---------------|---------|
| recording | Recording id | Long | 1 |
| copy_to_file | Copy recording data to file | String |   |
| compress_copy | GZip compress "copy_to_file" destination | Boolean | False |

Configuraition:

 * maxsize=size : Append the letter k or K to indicate kilobytes, m or M to indicate megabytes, g or G to indicate gigabytes, or do not specify any suffix to set the size in bytes.
 * maxage=age : Append the letter s to indicate seconds, m to indicate minutes, h to indicate hours, or d to indicate days. 
   If both a size limit and an age are specified, the data is deleted when either limit is reached.
 * delay=delay : Append the letter s to indicate seconds, m to indicate minutes, h to indicate hours, or d to indicate days
   Add a delay before the recording is actually started; e.g., when running from the command line, you might want the app to boot or reach a steady state before starting the recording
 * compress=true : Although the recording file format is very compact, you can compress it further by adding it to a ZIP archive with compress parameter

Sample usage:

    jcmd 5368 JFR.start duration=60s filename=myrecording.jfr

Automated way:

    MY_CMD=$(ps -ef | grep 'java ' | grep -v grep | grep ^${USER} | sed 's+/java +/jcmd +g' | awk '{print $8, $2}' | grep -v sed)
    
    #enable commercial features dynamically, this works from JVM>j8u40
    #for lower versions you need enable with parameters -XX:+UnlockCommercialFeatures -XX:+FlightRecorder 
    #CF_OPTIONS='VM.unlock_commercial_features'
    #${MY_CMD} ${CF_OPTIONS}
    
    #help on available options
    #JFR_OPTIONS='help'

    #simple status check
    JFR_OPTIONS='JFR.check'
    ${MY_CMD} ${JFR_OPTIONS}
    
    #simple 10 min recording
    time='600s'
    JFR_OPTIONS="JFR.start duration=${time} filename=${HOME}/debug.${HOSTNAME}.${time}.jfr"
    MY_CMD=$(ps -ef | grep 'java ' | grep -v grep | grep ^${USER} | sed 's+/java +/jcmd +g' | awk '{print $8, $2}' | grep -v sed)
    ${MY_CMD} ${JFR_OPTIONS}

Debug:

 * `-XX:FlightRecorderOptions=loglevel=debug`
 * `-XX:FlightRecorderOptions=loglevel=trace`


##### Finding deadlocks

List processes

    jps -l -m

    jstack 1234
    #Full thread dump Java HotSpot(TM) Client VM (1.8.0 ...
    #...
    #Found 1 deadlock.        

    jstack -m 28416
    #Attaching to process ID 28416, please wait...
    #Debugger attached successfully.
    #Server compiler detected.
    #JVM version is 25.131-b11
    #Deadlock Detection:
    #
    #No deadlocks found.
    #
    #----------------- 28417 -----------------
    #0x00007f3e0aa29965    #  __pthread_cond_wait + 0xc5
    #0x00007f3e09b25037    #  _ZN7Monitor5IWaitEP6Threadl + 0xf7
    #0x00007f3e09b25800    #  _ZN7Monitor4waitEblb + 0x100

jstack tells :

 * number of deadlocks existing JVM
 * waiting threads for each deadlock
 * stack traces of waiting threads (+ source code line numbers, if it was compiled with debug options)

##### Thread dump analysis

Thread Dump can help in debug of
 * thread races
 * deadlock
 * hanging IO calls
 * garbage collection / OutOfMemoryError problems
 * infinite looping

Thread dump is a snapshot taken at a given time, listing of all created Java Threads.
Each thread has:

 * name : human-readable name of the thread.
   Can be set by calling the `setName` method on a `Thread` object and be obtained with `getName` method
   `"Attach Listener"` #89 daemon prio=9 os_prio=0 tid=0x00007f3da4001000 nid=0x8a9 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

   `"DestroyJavaVM"` #36 prio=5 os_prio=0 tid=0x00007f3e04009800 nid=0x6f01 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

 * id : number, represents the unique ID of the thread, starts from 1 and increments for each newly created thread. Useful to get CPU and memory usage of the thread.
   It is read-only and can be obtained by calling `getId` on a `Thread` object.
   "Attach Listener" `#89` daemon prio=9 os_prio=0 tid=0x00007f3da4001000 nid=0x8a9 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

   "DestroyJavaVM" `#36` prio=5 os_prio=0 tid=0x00007f3e04009800 nid=0x6f01 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

 * deamon status : whether the thread is a daemon or non-daemon. Tag is present only for daemon threds (running in background and providing services to its user).
   "Attach Listener" #89 `daemon` prio=9 os_prio=0 tid=0x00007f3da4001000 nid=0x8a9 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

   "DestroyJavaVM" #36 prio=5 os_prio=0 tid=0x00007f3e04009800 nid=0x6f01 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

 * thread priority : represents the priority of the threads.
   Can be set using the `setPriority` method and obtained using the `getPriority` method of `Thread` object.

   "Attach Listener" #89 daemon `prio=9` os_prio=0 tid=0x00007f3da4001000 nid=0x8a9 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

   "DestroyJavaVM" #36 `prio=5` os_prio=0 tid=0x00007f3e04009800 nid=0x6f01 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

 * OS thread priority : corresponds to the OS thread on which the Java thread is dispatched
   "Attach Listener" #89 daemon prio=9 `os_prio=0` tid=0x00007f3da4001000 nid=0x8a9 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

   "DestroyJavaVM" #36 prio=5 `os_prio=0` tid=0x00007f3e04009800 nid=0x6f01 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

 * tid : the memory address of the Java native thread object.
   The address of the Java thread, represents the pointer address of the Java Native Interface (JNI) native Thread object.
   This is the C++ Thread object that backs the Java thread through the JNI
   Obtained by converting the pointer to this (of the C++ object that backs the Java Thread object) to an integer on line 879 of hotspot/share/runtime/thread.cpp:

       st->print("tid=" INTPTR_FORMAT " ", p2i(this));

   Although the key for this item (tid) may appear to be the thread ID, it is actually the address of the underlying JNI C++ Thread object
   It is not the ID returned when calling getId on a Java Thread object.

   "Attach Listener" #89 daemon prio=9 os_prio=0 `tid=0x00007f3da4001000` nid=0x8a9 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

   "DestroyJavaVM" #36 prio=5 os_prio=0 `tid=0x00007f3e04009800` nid=0x6f01 waiting on condition [0x0000000000000000]
      java.lang.Thread.State: RUNNABLE

  * nid : the unique native thread ID of the OS thread to which the Java Thread is mapped.
    The unique ID of the OS thread to which the Java Thread is mapped.
    It allows you to correlate  which threads from an OS perspective are using the most CPU within your JVM
    This value is printed on line 42 of hotspot/share/runtime/osThread.cpp:

        st->print("nid=0x%x ", thread_id());

  * status : human-readable string about thread state when the thread dump was generated
    It provides supplementary information beyond the basic thread state and can be useful in determinig the intended actions of a thread

    "Attach Listener" #89 daemon prio=9 os_prio=0 tid=0x00007f3da4001000 nid=0x8a9 `waiting on condition` [0x0000000000000000]
       java.lang.Thread.State: RUNNABLE

    "DestroyJavaVM" #36 prio=5 os_prio=0 tid=0x00007f3e04009800 nid=0x6f01 `waiting on condition` [0x0000000000000000]
       java.lang.Thread.State: RUNNABLE

 * stack pointer :  tThe last known Stack Pointer (SP) for the stack associated with the thread.
   This value is supplied using native C++ code and is interlaced with the Java Thread class using the JNI.
   For simple thread dumps, this information may not be useful, but for more complex diagnostics, this SP value can be used to trace lock acquisition through a program.
   This value is obtained using the last_Java_sp() native method and is formatted into the thread dump on line 2886 of hotspot/share/runtime/thread.cpp:
   
       st->print_cr("[" INTPTR_FORMAT "]", 
           (intptr_t)last_Java_sp() & ~right_n_bits(12));
   
   "MOM-ThreadPoolMonitorTimer" #33 daemon prio=5 os_prio=0 tid=0x00007f3e061d2000 nid=0x6f2d in Object.wait() `[0x00007f3dbe26b000]`

 * other information
   Thread stack trace : provides information needed in order to pinpoint root cause of many problems
   Stack trace resembles the stack trace printed when an uncaught exception occurs and denotes the class and line that the thread was executing when the dump was taken.

       "Thread-0" #12 prio=5 os_prio=0 tid=0x00000250e54d1800 nid=0xdec waiting for monitor entry  [0x000000b82b4ff000]
          java.lang.Thread.State: BLOCKED (on object monitor)
           at DeadlockProgram$DeadlockRunnable.run(DeadlockProgram.java:34)
           - waiting to lock <0x00000000894465b0> (a java.lang.Object)
           - locked <0x00000000894465a0> (a java.lang.Object)
           at java.lang.Thread.run(java.base@10.0.1/Thread.java:844)
          Locked ownable synchronizers:
           - None

Thread types

 * middleware, third party & custom threads : this portion is the core of the Thread Dump and maint task for analysis
 * HotSpot threads : internal thread managed by the HotSpot VM to perform internal native operations. Ususally not to worry about unless high CPU seen (via Thread Dump & prstat)
 * HotSpot GC threads : allows the VM to run periodic GC cleanups. High CPU observed from the OS / Java process(es) can be found with these their nid-s


##### Others

Oneliners

    java -XX:+PrintFlagsFinal -version  # print JVM defaults

Add jmx monitoring possibility

    -Djmx.rmi.port=43210
    -Dcom.sun.management.jmxremote.authenticate=false
    -Dcom.sun.management.jmxremote.ssl=false

Debug class content

    JAVA_HOME='/opt/java/x86-GNU_Linux_64bit/jdk1.7.0_60'
    #note, looks like symlinks are not accepted here
    ${JAVA_HOME}/bin/javap -classpath .:/lib/some.jar com.domain.class.path.MyClass | sed 's/).*/)/'

##### java 11 debug tools

based on data from: https://docs.oracle.com/en/java/javase/11/troubleshoot/diagnostic-tools.html

##### references

JVM internals
 * https://developers.redhat.com/articles/2021/08/20/stages-and-levels-java-garbage-collection
 * https://developers.redhat.com/articles/2021/09/09/how-jvm-uses-and-allocates-memory
 * https://developers.redhat.com/articles/2021/11/02/how-choose-best-java-garbage-collector?sc_cid=7013a000002pxeoAAA 
 * https://developers.redhat.com/articles/2021/10/29/beginners-attempt-optimizing-gcc?sc_cid=7013a000002pxeoAAA
 * https://docs.pega.com/pega-predictive-diagnostic-cloud/jvm-monitoring-landing-page-pega-predictive-diagnostic-cloud
 * http://www.fasterj.com/articles/oraclecollectors1.shtml - types of GC

Common issues
 * https://devops.egyan.space/common-issues-troubleshooting-in-weblogic/
 * https://stackify.com/memory-leaks-java/
