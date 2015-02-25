# aeon

Use aeon as a proxy in your browser, and play with the HTTP requests in it.

A pre-pre-pre-alpha screenshot:

![pre-pre-pre-alpha screenshot](http://i.stack.imgur.com/taE2D.png)

## Roadmap

- Passes the stream to be able to send back the response.
- Uses defvar to store the stream. Might as well use this var as a
  "queue", this way no need for semaphores or the likes. Just have
  something handling every new item in a queue one after one.
- Uses usocket:wait-for-input or the thread for the server socket dies.
- Adds a "Send request" button to be able to send the request once
  it's been modified in the app.
- Validate header names in the app.
- Map headers in the drakma:http-request call.


## License

MIT License.
