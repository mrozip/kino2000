import {
  app,
  type HttpRequest,
  type HttpResponseInit,
  type InvocationContext,
} from "@azure/functions";

export function healthResponse(): HttpResponseInit {
  return {
    status: 200,
    jsonBody: {
      service: "kino2000-api",
      status: "ok",
    },
  };
}

export async function health(
  _request: HttpRequest,
  context: InvocationContext,
): Promise<HttpResponseInit> {
  context.log("Health check requested");

  return healthResponse();
}

app.http("health", {
  authLevel: "anonymous",
  methods: ["GET"],
  route: "health",
  handler: health,
});
