# The Internet

The **internet** is the network of networks of computers, or servers, communicating with one another by sending and receiving data.

## Routers

**Routers** are specialized computers, with CPUs and memory, that routes, or relays, data from one point to another. At home or on campus, for example, we might have routers that accepts data and sends them out.

A router might have multiple options for what direction to send some data, and there are algorithms that try to figure out that direction.

## Protocols

**Protocols** are a set of rules or conventions, like a physical handshake for humans , that the world has agreed upon for computers to communicate with.

## TCP/IP

**TCP/IP** are two protocols for sending data between two computers. In the real world, we might write an address on an envelope in order to send a letter to someone, along with our own address for a letter in return.

### IP

**IP** stands for internet protocol, a protocol that includes a standard way for computers to address each other. **IP addresses** are unique addresses for computers connected to the internet, such that a packet sent from one computer to another will be passed along routers until it reaches its destination.

An IP address might have the format `#.#.#.#`, where each number can have a value from 0 to 255. Each number will be the size of one byte, so the entire address will be 4 bytes, or 32 bits. This means that this version of IP, version 4, can only support a maximum of 4 billion addresses. Another version of IP, version 6, uses 128 bits to support many more possible addresses.

### TCP

**TCP**, transmission control protocol, is a protocol for sending and receiving data. TCP allows for a single server, at the same IP address, to provide multiple services through the use of a **port number**, a small integer added to the IP address. For example, HTTP is sent to port number 80, and HTTPS uses port number 443.

- TCP also allows for a large amount of data, like an image, to be sent in smaller chunks. Each of them might be labeled with a sequence number, as with “part 1 of 4” or “part 2 of 4”. And if one of the parts is lost, the recipient can ask for the missing part again.
- UDP is another protocol for sending data that does not guarantee delivery like TCP, which might be useful for streaming real-time videos or calls, since we don’t want to wait for all the packets to be redelivered before we get new ones.

## DNS

**DNS**, domain name system, is another technology that translates domain names like cs50.harvard.edu to IP addresses. DNS is generally provided by a server nearby, with a big table in its memory, of domain names and IP addresses.

# The web

> The internet, with routers, IP, TCP, and DNS, is like the plumbing that allows us to send data from one computer to another. The web is one application that is built on top of the internet.

## HTTP

> HTTP is a protocol for sending and receiving data. HTTP is a request/response protocol, meaning that each request is made to a server, and the server responds with a response.
> **HTTP**, or Hypertext Transfer Protocol, standardizes how web browsers and web servers communicate within TCP/IP packets.

**HTTPS** is the secure version of HTTP, ensuring that the contents of packets between the browser and server are encrypted.

## URL

A **URL**, or web address, might look like https://www.example.com/.

- `https://` is the protocol being used.
- The `/` at the end is a request for the default file. It might also end in something like `/file.html` for a specific file.
- `example.com` is the domain name. `.com` is a top-level domain name, and others like `.edu` or `.io` indicate what type of website might be hosted there. Today, there are hundreds of top-level domain names, some with restrictions on how they can be used.
- `www` is the hostname, or subdomain, that refers to one or more specific servers in the domain name. A domain name might include web servers for `www`, or email servers for `mail`, so each subdomain can point to them separately.
- Together, `www.example.com` is a **fully qualified domain name**, or one that has a specific set of addresses.

## REQUEST and RESPONSE

### REQUEST

Two commands supported by HTTP include **GET** and **POST**. GET allows a browser to ask for a page or file in a URL, and POST allows a browser to send additional data to the server that is hidden from the URL. Both of these are **requests** we can make to a server, which will provide a **response** in return.

A GET request will start with:

```
GET / HTTP/1.1
Host: www.example.com
...
```

- The `GET` indicates that the request is for some file, and `/` indicates the default file.
- There are different versions of the HTTP protocol, so `HTTP/1.1` indicates that the browser is using version 1.1.
- `Host: www.example.com` indicates that the request is for `www.example.com`, since the same web server might be hosting multiple websites and domains.

### RESPONSE

A response for a successful request will start with:

```
HTTP/1.1 200 OK
Content-Type: text/html
...
```

- The web server will respond with the version of HTTP, followed by a status code, which is 200 OK here, indicating that the request was valid.
- Then, the web server indicates the type of content in its response, which might be text, image, or other format.
- Finally, the rest of the packet or packets will include the content.

### HTPP headers

HTTP headers are pieces of information that are sent with the request and response.

The keys and values, like `Host: www.example.com` and `Content-Type: text/html`, are known as HTTP headers.

We’ll type in `http://harvard.edu` in our browser, and see that the address bar has changed to` https://www.harvard.edu` after the page has loaded. Browsers include developer tools, which allow us to see what’s happening. In Chrome’s menu, for example, we can go to View > Developer > Developer Tools, which will open a panel on the screen. We’ll also use an Incognito window, so Chrome doesn’t remember our previous requests.

In the Network tab, we can see that there were over a hundred requests, for text, images, and other pieces of data that were downloaded separately for a single web page. It turns out that our browser made a single request, and the response from the server indicated that we needed to make all those other requests to download the other data on the page.

And we can scroll to see that the server’s response actually returned a status code of `301 Moved Permanently`, redirecting our browser from `http://`... to `https://`...:

![Snipaste_2022-08-09_11-08-41.png](https://media.haochen.me/Snipaste_2022-08-09_11-08-41.png)

In VS Code’s terminal, we can use a command-line tool, `curl`, to see the response headers for a request as well:

```
$ curl -I -X GET http://harvard.edu/
HTTP/1.1 301 Moved Permanently
Retry-After: 0
Content-Length: 0
Server: Pantheon
Location: https://www.harvard.edu/
...
```

## HTTP status codes

- `200 OK`
- `301 Moved Permanently`
- `302 Found`
- `304 Not Modified`
- `307 Temporary Redirect`
- `401 Unauthorized`
- `403 Forbidden`
- `404 Not Found`
- `418 I'm a Teapot`
  - An April Fool’s joke years ago
- `500 Internal Server Error`
  - Buggy code on a server might result in this status code, like segfaults we might have seen in C.
- `503 Service Unavailable`

# HTML

> Now that we can use the internet and HTTP to send and receive messages, it’s time to see what’s in the content for web pages. **HTML**, Hypertext Markup Language, is not a programming language, but rather used to format web pages and tell the browser how to display them.

## table

```html
<!DOCTYPE html>

<html lang="en">
  <head>
    <title>table</title>
  </head>
  <body>
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Number</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Carter</td>
          <td>+1-617-495-1000</td>
        </tr>
        <tr>
          <td>David</td>
          <td>+1-949-468-2750</td>
        </tr>
      </tbody>
    </table>
  </body>
</html>
```

## form

```html
<form action="https://www.google.com/search" method="get">
  <input
    autocomplete="off"
    autofocus
    name="q"
    type="text"
    placeholder="Query"
  />
  <input type="submit" />
</form>
```

# CSS

```html
<!DOCTYPE html>

<html lang="en">
  <head>
    <title>home</title>
  </head>
  <body style="text-align: center;">
    <header style="font-size: large;">John Harvard</header>
    <main style="font-size: medium;">Welcome to my home page!</main>
    <footer style="font-size: small;">
      Copyright &#169; John Harvard
      <!-- We’ll also use an HTML entity to represent the copyright symbol, which will be displayed in our browser as ©. -->
    </footer>
  </body>
</html>
```

We’ll also use an HTML entity to represent the copyright symbol, which will be displayed in our browser as ©.

We can also include CSS in our HTML file

```html
<head>
  <style></style>
</head>
```

Finally, we can take all of the CSS for the properties and move them to another file with the `<link>` tag:

```html
<head>
  <link href="home.css" rel="stylesheet" />
  <title>home</title>
</head>
```

# Framework

Bootstrap is a very popular framework.

```
$ npm i bootstrap@5.2.0
```
