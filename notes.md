# Elm in Action - Notes:

## Page summaries:

- p. 8 : Strong type system, also for operators (+ for numbers, ++ for strings)
- Double Quotes are for strings, single quotes are for utf-8 characters aka "chars"

### Conventions:

- p. 10:
  - all letters in a naming should be uninterrupted
  - camelCase is preferred
- p. 31: use the direct element function, instead of `node` whenever possible
- p. 33: commas for a multiline literal in Elm should be in front of the next line, not the last as in js
  - this is due to the fact, that it would be still valid, but a wrong number of arguments
  - this guideline can help to reduce those errors
- p. 37: Don't expose everything from a module to your file, only if it's something like the `Html`module, which is meant to resemble Html-Markup

### Expressions:

- p. 10: "An expression is anything that evaluates to a single value."
  - Everything in Elm is mostly an expression. It's the basic building block: especially functions consist of expressions
  - The classic `if{...} else{} ` from js is not an expression, the ternary is one, because it evaluates to a single value
    - `if` in Elm is used therefore in "if-Expressions", rather then "if-Statements"
    - example:
    ```elm
        elfLabel v = if v == 1 then "elf" else "elves"
    ```
    - The `else` part is mandatory(!) in Elm: p. 12
- p. 11: `!==` is `/=` in the Elm world, `!something` is `not(something)`

### Functions:

- p. 13: A function represents re-usable logic in Elm. It has no fields and nothing to store, it only accepts values in form of arguments and returns a value
- p. 14: no return value for functions, because Elm only has a function body in form of an expression aka "evaluates to a single value"

  - --> no early returns as we know them from js!

  ```js
      function capitalize(str) {
      if (!str) {
          return str; }
          Early return
          return str[0].toUpperCase() + str.slice(1);
      }

      // the elm way would be --->

      function capitalize(str) {
          return !str ? str : str[0].toUpperCase() + str.slice(1);
      }

  ```

- p. 15: Spaces are right, tabs are an error in Elm
- p. 16: There are no methods or fields on values like on "string" in js, e.g. : `value.toString()`
- p. 18: **High Order Function** : A function, that accepts other functions as arguments, like `String.filter [function argument] --> filtered output`
- p. 18: **Let Expression** : A way of scoping values, methods, etc. to one function. It's wrapped inside like that:

  ```elm
      withoutDashes str =
          let
              dash =
                  '-'

              isKeepable character =
                  character /= dash
          in
          String.filter isKeepable str
  ```

- p. 19: _ Anonymous Functions _ : no name, begin with `\`, use `->` instead if `=`, e.g.: `\w h -> w * h`
  - especially useful as an argument to other functions, e.g. the string filter function
- p. 47: Functions in Elm are _curied_ by default. This means: They accept less then the specified arguments, because they return a new function which will then accept the next argument, and so on.
  - In js something like this would be done by doing:
    ```js
    function splitA(sep) {
        return function(str) {
            return str.split(sep); }
        }
    }
    ```
  - In Elm you would write something like this:
  ```elm
  List.map (\photo -> viewThumbnail model.selectedUrl photo) model.photos
  --- can be written like this:
  List.map (viewThumbnail model.selectedUrl) model.photos
  ```
  - The general rule of thumb is, something like:
  ```elm
  (\foo -> bar baz foo) -- can always be re-written to:
  (bar baz)
  ```

### Operators:

- p. 20: Operators are nothing else then functions in Elm, the only accept exactly two arguments, aka they compare two values
  - usually we write operators in "infix-style", aka `value [operator] value`, but you can also write it in "prefix-style"
  ```elm
      7 - 4 == 3 --- returns True
      (-) 7 4 == 3 --- also returns True
  ```
  ```bash
    > (-)
     <function> : number -> number -> number
  ```

### Collections aka data structures:

- p. 22: Elm has basic collections in form of lists, records and tuples, **they are always immutable**
  - **Lists** in Elm consist of values of the same type, they have no methods, they can vary in size
    - this is true for almost all collections, it allows predictability and safer code
    - they resemble as the immutable version of javascript arrays
    - there are multiple functions to work with lists, e.g there is `List.filter ` or `List.map`
      - p. 45: `List.map` is almost the same as in js, just with another syntax which seems a bit weird at first:
      ```elm
          collection = List.map (\item -> doSomething arg1 arg2 etc) items
          -- the first argument is the function which specifies how the mapping over each item should be performed
          -- the second argument is the list collection, you want to iterate over
      ```
- p. 24f.:

  - **Records** is a collection of fixed named fields with their values of varying type

    - fields can not be added or removed
    - they are the "objects from javascript" in Elm, e.g.

    ```elm
        { name = "Li", cats = 2 } -- they use "=" as delimiter, instead of ":" in js
    ```

    - as usual: they are immutable, modifying them is only possible through "record updates"

      - it works almost like the "spread operator" in js, the syntax is:

      ```elm
          myObject = { name = "User", likes = 2 }
          myUpdatedObject = { myObject | likes = 3 } -- increment likes with new value
      ```

    - they are basically only "key:value storage", no fancy js magic around like `Object.keys({...})`

- p. 26:
  - **Tuples** it's a collection with of values with (potentially) different types
  - max 3 values, mostly common are two value pairs, like `("key", "value")`
  - e.g.
  ```elm
      myTuple = ("name", 2, "whatever")
  ```
  - tuples are not a function, even if they have brackets when deconstructing: "Comma means tuple!"

### Types:

- p. 58: Types are tightly coupled to Elm. You generally can and should annotate your code by using them

  - Annotations are always have to appear on top of the declaration of something, e.g.:

  ```elm
  url : String
  url = "test" -- a number like '2' or something else would fail here

  isEmpty : String -> Bool -- functions use an arrow to differentiate inputs from outputs
  isEmpty str = str == ""

  ```

- p. 59: Types can be a variable. This allows to place a type definition as a placeholder. Type variables always need to start lowercase. This differentiates them from _concrete types_, e.g.: `String`
  - That's particular useful for expressing a function that accepts something of a type returns something of exactly that type, e.g.:
  ```elm
  fromList : List elementType -> Array elementType -- returns an array representation of the given list
  --- which could be used to realize both:
  fromList : List String -> Array String
  -- or
  fromList : List Float -> Array Float
  ```
- p. 61: Types can have alias. That means you define basically a type, which you can then use in different parts of your code to refer to exactly that type.

```elm
type alias Photo : { url : String }
```

- p. 64: If a function has multiple arguments, you need to type it in the way that elm will call this function, aka they are curried by default (!)

  - This means Elm will always treat a function that way, that it can also be just partially applied, e.g.:

  ```elm
  sayHello : String -> String -> String
  sayHello firstName lastName = "Hello" ++ firstName ++ " " ++ lastName

  --- partially applied:
  sayHello "Michael"
  > String -> String -- aka one String to go to return the final String
  ```

  - Elm is therefore technically only calling functions, which take one argument at a time

- p. 67f.: Enums are called **Custom Types** in Elm. Like that it can be specified which values a type can contain

### Page rendering in Elm:

- p. 31: In Elm you don't write markup, you call functions (what else?), which create the DOM representations for you.
  ```elm
  -- creating a DOM node with elm, using the "node" function:
      node "button" [class "funky", id "submitter"] [text "Submit"]
  --  js would be something like: node function( arg1: string,   [argList of functions],  [argList2 of functions] )
  ```
  - the `Html` module in Elm is exporting these functions, it's also possible to drop the "node" in front of it, because the module is also providing convenience methods, that let you call the element function directly, e.g. calling
  ```elm
      button [class "someClass"] [text "Click me"]
  --  it's always function([list_of_attribute_functions], [list_of_children])
  ```

### The Elm Runtime:

- p. 39: the code from elm, which runs in the background to enable application state, event listening, scheduling Dom updates, etc.
- p. 40: [Elm Architecture](./assets/Elm_Architecture_Diagramm.png)
- p. 41: **State** in Elm is stored inside "Model"
  - the "View" function should base it's return values on the "model" (mode, view, controller?)
  - p. 48: state is modified through the "update" function.
- p. 49: **Update Function**:
  - The update function needs always to return a "fresh" model. This means if nothing was updated, it should just return "model" on it's own, even if it's the same as before.
  - The update function processes "messages", which were sent. Messages are values which are passed between systems
  - After the update function has run, the view returns always a fresh html (!=DOM is not re-created, like in React and other frameworks)
- p. 50f.: The _Browser_ module is the module which is needed to create an interactive application. It's describing too the elm runtime how the view (=html) looks like and how to deal with events via update(=processes the messages and updates the elm state if needed).
- p. 53: The **View** function is the place where the html is defined (like the render function in React)

## Screenshots:

- the compiler is your [best friend](./assets/nice_elm_compiler_message.png)
