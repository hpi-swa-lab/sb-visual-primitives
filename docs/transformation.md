# Creating a Transformation

Here, we detail how to use domain blocks to write visual code.

We walk through creating a transformation to replace some previously non-visual code.

We also explain how to edit domain blocks and patterns with the help of shortcuts.

[Video]

## Additional features not mentioned in this tutorial
* In addition to binding names and literals, labels can also be assigned with outside variables or any other Smalltalk expressions. To that end, either enter a block closure into the label by pressing `[` or select 'variable' from the suggestions.
* The identity of a binding pattern can also be assigned with an expression. This expression needs to evaluate to an object that defines a domain block mapping. Such a binding pattern will only bind to objects that are equal to that object. (Experimental: When any binding pattern has its identity defined by an expression, it is possible to call the transformation using `value` instead of `value:` and the pattern matching should automatically be performed on the structure that the object is part of.)
* Binding patterns on the right side of the transformation can also have labels: The corresponding label in the output object is then set to the value associated with the binding index or the value of the expression.
* You can visualize individual binding patterns according to a different domain block mapping by selecting them and using the `changeVisualizingClass` command.
* (Experimental: You can turn binding patterns into wildcards using the `convertToWildcardPattern` command. Wildcards can bind to any non-empty subtrees. Their children can be the children of any node in that subtree.)
* Instead of using a transformation, you can also perform pattern matching using an `SBQuery`. It contains only one pattern and does not perform any transformation. Instead, it only checks whether the pattern matches the given object and returns `nil` if it doesn't, otherwise a dictionary containing all the bindings.
