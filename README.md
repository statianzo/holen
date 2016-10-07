# Holen

A thin Promise-based wrapper over XmlHttpRequest.

## Installation

```
npm install holen
```

## Usage

```js
import holen from 'holen';

holen.ajax({
  url: 'http://example.com/user/1.json',
  method: 'GET',
})
.then((res) => {
  console.log(res.body.name);
});
```

## Rationale

Holen is a no frills ajax library striving to cover the 80% case. It relies on
native promises instead of its own half-baked implementation. Holen is small
and focused. No middleware, jsonp, or caching. Just ajax.
