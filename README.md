# Fibers on Ruby



### Sobre el tamaño del stack de Threads y Fibers  

Podemos comprobar rápidamente el tamaño de la pila para un `Thread` y para las` Fibers` en ruby ​​comprobando `RubyVM :: DEFAULT_PARAMS` en la consola irb o pry:

```ruby
pry(main)> RubyVM::DEFAULT_PARAMS
=> {:thread_vm_stack_size=>1048576,
 :thread_machine_stack_size=>1048576,
 :fiber_vm_stack_size=>131072,
 :fiber_machine_stack_size=>524288}
```

> Esto solo es valido para versiones de Ruby >= 2.0.0

Ahora podemos comprobar rápidamente el tamaño de la pila de los `hilos` tal como están

Esto muestra claramente que el tamaño de la pila para los subprocesos en ruby ​​es solo de 1 MB, mientras que el tamaño de la pila para las fibras es de solo 512k. Podemos cambiar esto haciendo una exportación de cada una de las variables, como por ejemplo:


```dotenv
export RUBY_FIBER_VM_STACK_SIZE=2097152
export RUBY_THREAD_VM_STACK_SIZE=2097152
```

Esto aumentará el tamaño de la pila y las veces que podemos llamar a una pila anidada.

Con stack size de 1MB

```ruby
$ ruby stack_size.rb 
Max Stack Level: 10079
```

Con un stack de 2MB

```ruby
altair.λ:~/utn/iasc/fibers-ruby/extras$ ruby stack_size.rb 
Max Stack Level: 20161
```

Podemos ver que es casi linea la cantidad de veces que podemos llamar al stack con el stack size que tenemos.

> Esto puede variar dependiendo de la informacion y de los datos que guardemos en el stack.