import { describe, expect, it } from "vitest";

import { healthResponse } from "../src/functions/health.js";

describe("healthResponse", () => {
  it("returns an ok response for the health endpoint", () => {
    expect(healthResponse()).toEqual({
      status: 200,
      jsonBody: {
        service: "kino2000-api",
        status: "ok",
      },
    });
  });
});
