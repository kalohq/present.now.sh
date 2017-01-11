# <a id="/"></a>[present.now.sh](https://present.now.sh)

This is a proof of concept for using web components as microservices on the frontend. It consists of four different services ([timer-controls](#/timer-controls), [timer-display](#/timer-display), [style-guide](#/style-guide) and [inline-input](#/inline-input)), plus a [glue layer](#/glue-layer) to stitch things together.



## setup

<pre>
yarn install
scripts/bower install  # <a href="#/faq/polymer">what the frick?</a>
</pre>



## <a id="/timer-controls"></a>[timer-controls](./timer-controls)

The only fairly complex service around here – handling interactions while setting up the talk. Written in Elm. Elm’s ports and flags play together with the custom elements API wonderfully, so [wiring this up](./timer-controls/build/bundle/timer-controls.js) was a breeze.

To mount it without the rest of the app, run `timer-controls/scripts/mount --open`. You can pass the `--debug` flag to see some Elm goodness.



## <a id="/timer-display"></a>[timer-display](./timer-display)

Written in React as an ES5 script without a build step. A pleasure to write the component itself, but [wiring this up as a custom element](./timer-display/dist/script.js#L105) required a minimal amount of manual state management.

To mount the microservice on its own, run `timer-display/scripts/mount --open`.



## <a id="/style-guide"></a>[style-guide](./style-guide)

Most apps running on frontend microservices have a single, lightweight style guide under the hood. It’s making sure the whole app feels consistent.

This one is super rough, just [a few lines of global CSS](./style-guide/style-guide.html). A real-world example would surely be more involved, but probably still kept low-tech. Just like Zalando’s [dress-code](https://zalando.github.io/dress-code/).



## <a id="/inline-input"></a>[inline-input](./inline-input)

We’ve also had a go at writing a component in pure JS. No framework, no architectural conventions, no build. As close to the bare metal as it gets.

Turned into quite a [blob of spaghetti code](./inline-input/inline-input.js). Interesting as an experiment, but we wouldn’t recommend this in a large-scale project.



## <a id="/faq"></a>Frequently Asked Questions

<h3 id="/faq/bower">why does the app weigh 1 MB?<br/>why bower?<br/>why do some parts of the app load slower than others?</h3>

To roll this out as quickly as possible but still make it feel nice, we picked some ready-made Polymer elements. They’re super easy to use in any of the technologies we built the services (Elm, React, vanilla JS, vanilla HTML) – and they’re done nicely. They deliver native-like performance even on a crappy old low-end phone. The tradeoffs are: they weigh a ton, plus they use bower.

But hey, look at it from the other side! Even though we pull down three runtimes (Polymer, React, Elm) and half the jungle, the app is usable immediately! As different bits and pieces arrive, parts of the app upgrade to become usable. That’s one of the great wins when using web components as microservices.

<h3 id="/faq/requests">66 requests and you call is fast</h3>

[present.now.sh](https://present.now.sh/) is served over HTTP/2, so unless you’re using an ancient browser it should be just about as fast as one request of the same size.

The upside of having everything in separate requests lies in performance again. Halfway through loading time, you have half the app usable. If we served everything over a single request, we’d have to wait for everything to be downloaded, then parsed, then executed before we could start using the app.



## License

MIT © Tomek Wiszniewski, Lystable
