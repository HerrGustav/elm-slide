# Elm in Action - Notes:

## Page summaries:
- p. 8 : Strong type system, also for operators (+ for numbers, ++ for strings)
- Double Quotes are for strings, single quotes are for utf-8 characters aka "chars"

#### Conventions:
- p. 10: conventions:
    - all letters in a naming should be uninterrupted 
    - camelCase is preferred

#### Expressions:
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

#### Functions:
- p. 13: A function represents re-usable logic in Elm. It has no fields and nothing to store, it only accepts values in form of arguments and returns a value
- p. 14: no return value for functions, because Elm only has a function body in form of an expression aka "evaluates to a single value"
    - --> no early returns as we know them from js!
    - ```
    function capitalize(str) {
    if (!str) {
        return str; }
        Early return
        return str[0].toUpperCase() + str.slice(1); 
    }

    // --->

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
- p. 19: * Anonymous Functions * : no name, begin with `\`, use `->` instead if `=`, e.g.: `\w h -> w * h`
    - especially useful as an argument to other functions, e.g. the string filter function

#### Operators:
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

#### Collections aka data structures
- p. 22: Elm has basic collections in form of lists, records and tuples, **they are always immutable**
    - **Lists** in Elm consist of values of the same type, it has no methods, they can vary in size
        - this is true for almost all collections, it allows predictability and safer code
        - they resemble as the immutable version of javascript arrays 
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
    ```elm
    -- deconstructing a tuple:
    t = ("test", 2, 3, "something")
    deconstructedTuple (a, b, c, d) = 
    ```
    

    


## Screenshots:    
- the compiler is your [best friend](./assets/nice_elm_compiler_message.png)


