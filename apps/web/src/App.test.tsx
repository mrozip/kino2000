import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { App } from "./App";

describe("App", () => {
  it("renders the sprint 0 placeholder welcome screen", () => {
    render(<App />);

    expect(screen.getByRole("heading", { name: "Welcome to kino2000" })).toBeInTheDocument();
    expect(screen.getByText(/log, rate, and favourite movies/i)).toBeInTheDocument();
  });
});
