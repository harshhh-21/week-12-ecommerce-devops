import test from "node:test";
import assert from "node:assert/strict";
import express from "express";
import healthRouter from "../src/routes/health.routes.js";

test("GET / returns a healthy status and message", async () => {
  const app = express();
  app.use("/", healthRouter);

  const server = app.listen(0);

  try {
    const address = server.address();
    const response = await fetch(`http://127.0.0.1:${address.port}/`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.equal(body.status, "ok");
    assert.equal(body.message, "Server is healthy");
    assert.equal(typeof body.uptime, "number");
  } finally {
    await new Promise((resolve, reject) => {
      server.close((error) => error ? reject(error) : resolve());
    });
  }
});
