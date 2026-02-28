import { Router } from "express";

export default (rootDirectory: string): Router[] => {
  const router = Router();
  
  router.get("/health", (req, res) => {
    res.json({ status: "ok" });
  });

  return [router];
};
