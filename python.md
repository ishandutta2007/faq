#### Python

Variables evaluation sample

    print result.name + ":" + item + ":" + str(eval('result.' + item))
                    
Debug in ipython

    myObj??
    myObj.method??

Debug in python

    def dump(obj):
      for attr in dir(obj):
        print("obj.%s = %r" % (attr, getattr(obj, attr)))
    
    dump(myObj)
    vars(myObj)
    dict(myObj)
    
    obj=...
    for attr, value in obj.__dict__.iteritems():
        print attr, value 

Others

    x.y == x['y']
    x.y == x._data['y']

References

 * https://jakevdp.github.io/PythonDataScienceHandbook/


