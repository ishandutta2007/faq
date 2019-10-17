#### Jython

##### Comparison with beanshell


Importing Java packages

 * BeanShell
   Same as Java

       import java.awt.\*;
       import javax.swing.\*;

   By default, BeanShell imports

    * java.lang
    * java.util
    * java.io
    * java.net
    * java.awt
    * java.awt.event
    * javax.swing
    * javax.swing.event

   There is also (an experimental) import entire classpath option - which may be useful in interactive use.

       import \*

 * Jython

       from java.util import \*

Importing specific class(es)

 * BeanShell
   Same as Java

       import javax.swing.JFrame;
   
   By default, BeanShell imports

    * bsh.EvalError
    * bsh.Interpreter

 * Jython

       from javax.swing import JFrame

Type alias (Referring Java class with different name)

 * BeanShell
   It does not seem possible. You can assign class name to a variable - resulting variable is of type "ClassIdentifier". But, it does not appear that you can treat class identifier as though it is a class.

       JF = javax.swing.JFrame
       // prints "Class Identifier: javax.swing.JFrame"
       print(JF)


 * Jython

       from javax.swing import JFrame
       JF = JFrame
       print(JF)

Creating a Java object

 * BeanShell
   Same as Java

       f = new JFrame("hello");

 * Jython

       from javax.swing import JFrame
       # treat class name as a function name
       # just call as though it is a function.
       f = JFrame("hello")

Calling instance methods

 * BeanShell
   Same as Java

       f = new javax.swing.JFrame("hello");
       f.setSize(100, 100);
       f.setVisible(true);

 * Jython

       from javax.swing import JFrame
       f = JFrame("hello")
       f.setSize(100, 100)
       f.setVisible(1)

Calling static methods

 * BeanShell
   Same as Java

       java.lang.System.exit(0)

 * Jython

       from java.lang import System
       System.exit(0)

JavaBean support

 * BeanShell

       f = new JFrame("hello");
       f.setSize(100, 100);
       // calls setVisible
       f.visible = true;
       // calls getTitle for "title" access
       print(f.title);


 * Jython

       from javax.swing import JFrame
       f = JFrame("hello")
       f.setSize(100, 100)
       # calls setVisible
       f.visible = 1;
       # calls getTitle for "title" access
       print(f.title);

instanceof check

 * BeanShell
   Same as Java

       f = new JFrame("hello");
       // prints true
       print(f instanceof JFrame);

 * Jython

       from javax.swing import JFrame
       f = JFrame("hello")
       # prints "1"
       print(isinstance(f, JFrame))

Java overloaded resolution

* BeanShell
  BeanShell automatically selects the overload method to call (based on java overload resolution algorithm) using argument types. 
  It seems we need to use reflection to force selection of a particular method.


 * Jython
   There is automatic selection of the overload variant based on arguments.
   But if there are two methods, say void `func(int x)` and `void func(byte x)`, to call the second method you can write:

       from java.lang import Byte
       func(Byte(10))

Another example:

       from java.lang import Double
       from java.lang import System
       System.out.println(Double(33.33))

Handling Java exceptions

 * BeanShell
   Same as Java

       try {
        ioFunc();
       } catch (IOException e) {
        print("caught it: " + e);
       } catch (EOFException e1) {
        print("caught it: " + e1);
       }
       
   It is possible to omit the exception type in catch clause:

       try {
        ioFunc();
       } catch(e) {
        e.printStackTrace();
       } 


 * Jython

       from java.io import \*
       import sys
       try:
        f = FileInputStream("myfile")
        c = f.read()
       except FileNotFoundException:
        print(sys.exc_info())
       except IOException:
        print(sys.exc_info())

Creating Java Arrays

 * BeanShell
   Same as Java

       s = new String[2];
       print(s);

 * Jython
   "jarray" module is used to create Java arrays.
    The jarray module exports two functions: `array(sequence, type)` and `zeros(length, type)`
    `array` will create a new array of the same length as the input sequence and will populate it with the values in sequence.
    `zeros` will create a new array of the given length filled with zeros (or null's if appropriate).

       from java.lang import String
       import jarray
       s = jarray.zeros(2, String)
       print(s)

   Another example:

       from java.lang import String
       import jarray
       s = jarray.array(["hello", "world"], String)
       print(s)

Accessing Java Arrays

 * BeanShell
   Same as Java
   usual [] and .length are supported.

       s = new String[2];
       s[0] = "hello";
       s[1] = "world";
       print(s.length);
       print(s[0]);
       print(s[1]);

 * Jython
   Similar to Java [] operator for access - but array length is accessed by "len" function.

       from java.lang import String
       import jarray
       s = jarray.zeros(2, String)
       s[0] = "hello";
       s[1] = "world";
       print(len(s))
       print(s[0])
       print(s[1])

Implementing a Java interface

 * BeanShell
   Same as Java (except loose typing can be used)

       r = new Runnable() {
        run() {
         print("I'm runnable");
        }
       };
       print(r instanceof Runnable);
       r.run();

       class MyRunnable implements Runnable {
        public void run() {
         print("hello world");
        }
       }
       new MyRunnable().run();


 * Jython

       from java.lang import Runnable
       from java.lang import Thread
       # just extend like a Python 
       # super class
       class MyRunnable(Runnable):
       def run(self):
       print("run called")
       t = Thread(MyRunnable())
       t.start()

Implementing multiple interfaces

 * BeanShell
   Same as Java (except that loose typing may be used in few places)

       import java.util.concurrent.Callable;

       class MyClass implements Runnable, Callable {
        public void run() {
         print("run called");
        }
        public call() {
         print("call called");
        }
       }

       m = new MyClass();
       print(m instanceof Runnable);
       print(m instanceof Callable);
       m.run();
       m.call();

 * Jython
   Jython supports multiple inheritance. Treat each Java interface to be implemented as a "superclass".

       from java.util.concurrent import Callable
       from java.lang import Runnable
       class MyClass(Runnable, Callable):
       def run(self):
       print("run called")
       def call(self):
       print("call called")
       m = MyClass()
       # prints 1
       print(isinstance(m, Runnable))
       # prints 1
       print(isinstance(m, Callable))
       m.run()
       m.call()

Extending a Java class

 * BeanShell
   Same as Java (except that loose typing may be used)

       class MyHashtable extends Hashtable {
        // Override Hashtable.get method
        public get(key) {
         print("get called");
         // call super class method
         return super.get(key);
        }
       }

       m = new MyHashtable();
       m.put("hello", "world");
       print(m.get("hello"));

 * Jython

       from javax.swing import JFrame
       class MyFrame(JFrame):
       # override method
       def setVisible(self, flag):
       print("set visible")
       # call super class methodJFrame.setVisible(self, flag)
       f = MyFrame("hello")
       print(isinstance(f, JFrame))
       f.setVisible(1)

