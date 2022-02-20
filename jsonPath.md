#### jsonPath

jsonPath vs xmlPath, see https://www.ietf.org/id/draft-ietf-jsonpath-base-02.html

Comparison

    XPath     JSONPath          Description
    /         $                 the root element/node
    .         @                 the current element/node
    /         . or []           child operator
    ..         n/a              parent operator
    //        ..                nested descendants (JSONPath borrows this syntax from E4X)
    *         *                 wildcard: All elements/nodes regardless of their names
    @         n/a               attribute access: JSON values do not have attributes
    []        []                subscript operator: XPath uses it to iterate over element collections and for predicates; native array indexing as in JavaScript here
    |         [,]               Union operator in XPath (result is combination of node sets); JSONPath allows alternate names or array indices as a set
    n/a       [start:end:step]  array slice operator borrowed from ES4
    []        ?()               applies a filter (script) expression
    n/a       ()                expression engine
    ()        n/a               grouping in Xpath

Examples

    XPath                 JSONPath                Result
    /store/book/author    $.store.book[*].author  the authors of all books in the store
    //author              $..author               all authors
    /store/*              $.store.*               all things in store, which are some books and a red bicycle
    /store//price         $.store..price          the prices of everything in the store
    //book[3]             $..book[2]              the third book
    //book[last()]        $..book[(@.length-1)]
                          $..book[-1]             the last book in order
    //book[position()<3]  $..book[0,1]
                          $..book[:2]             the first two books
    //book[isbn]          $..book[?(@.isbn)]      filter all books with isbn number
    //book[price<10]      $..book[?(@.price<10)]  filter all books cheaper than 10
    //*                                           all elements in XML document; all member values and array elements contained in input value
