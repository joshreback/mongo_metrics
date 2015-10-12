# Managing Application Events With Mountable Engines

Show all actions processed by our application and store them in a MongoDB database.
Expose this data through a mountable engine which can be shared across Rails applications.

### Mountable and Isolated Engines

- A mountable engine uses its own router instead of adding routes directly to the application router.
- An isolated engine is built inside its own namespace, with its own models, controllers, views, assets, and helpers.
- Mountable engine's routes need to be explicitly mounted in the application router

- These are an alternative to engines which directly extend the application its used in
  - Can lead to method conflicts if it's a large plugin with lots of helpers


### Storing Notifications in the database.

- The Notifications API consists of two methods: `instrument` (for publishing an event) and `subscribe` (for subscribing to the event)

### Rails and Rack

- Rails applications need a web server in order to interact through the HTTP protocol
- Before, Rails used to have to provide an adapter for each webserver it supported: Thin, Mongrel, etc.
- Other frameworks had to also provide adapters since they had a different API than Rails
- The motivation for Rack is to unify the APIs used by web servers and web frameworks

* The Rack API *
- A Rack application is any Ruby object that responds to `call`
- It takes one argument: the environment. It returns an array of three values: the status, the headers, and the body.
- Every Rails application is also a Rack application b/c it implements the interface described above
  - It sends the request to the application router, which dispatches the request to another Rack application (which?) if any route matches
  - Rails automatically converts the 'controller#index' recipient of a route to a Rack application
  - If you do:  `PostsController.action(:index).responds_to?(:call)  # => true`
- The matching mechanism is smart about matching mounted routes and normal routes and dispatching them accordingly

* Middleware Stacks *
- A middleware wraps around a Rack application, which lets us manipulate the request sent down to the application and the response the application returns
- Multiple middlewares comprise a middleware stack
- Since controllers are also Rack applications, they can have their own middleware stacks
  - You can invoke certain middlewares on a controller by controller basis, and it will be invoked before any filters and before the action is processed

- (Goal with middlewares is to turn off the metrics store when we are hitting the engine itself)
- Any Rack middleware is initialized with the application or the middleware it should call next in the stack

### Streaming with Rack

- In Chapter 5 we used Rails's live-streaming facilities to stream data; here we'll use Rack's
- Rack specifies that a valid response body is any Ruby objecdt that responds to the method `each()`
- The Rack web server will loop over the response body, using the `each()` method, and output the data yielded
- To enable streaming, we need to have a custom iteration mechanism that responds to `each()`
  - i.e, could be as simple as an object with an each method that continues to yield a response body
  '''
  class StreamingRack
    def call(env)
      [200, { 'Content-Type' => 'text/html' }, self]
    end

    def each
      while true
        yield 'Hello Rack!\n'
      end
    end
  end
  '''