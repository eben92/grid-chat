// export { default } from "next-auth/middleware";///
import { getToken } from "next-auth/jwt";
import { withAuth } from "next-auth/middleware";
import { NextResponse } from "next/server";
import { encodeUrl } from "./utils/helpers";

export default withAuth(
  async function middleware(req) {
    const pathname = req.nextUrl.pathname; // relative path
    const fullURL = req.nextUrl.href; // relative url

    // manage route protection
    const token = await getToken({ req });
    const isAuth = !!token;
    const isAuthPage = pathname.startsWith("/auth");
    const sensitiveRoutes = ["/home", "/settings", "/chat", "/dm"];

    console.log("pathname", pathname);

    const decodedCallbackUrl = encodeUrl(fullURL).toString("utf-8"); // your large string here
    // const buffer = Buffer.from(largeString, 'utf-8'); // convert the string to a Buffer object
    // use the buffer as needed
    // const decodedString = buffer.toString('utf-8'); // decode the buffer back to a string when needed

    if (isAuthPage && isAuth) {
      return NextResponse.redirect(new URL("/", req.url));
    }

    if (
      !isAuth &&
      sensitiveRoutes.some((route) => pathname.startsWith(route))
    ) {
      return NextResponse.redirect(
        new URL(`/auth/signin?callbackUrl=${decodedCallbackUrl}`, req.url)
      );
    }
  },
  {
    callbacks: {
      async authorized() {
        return true;
      },
    },
  }
);

export const config = {
  matcher: ["/home", "/settings", "/chat/:path*", "/dm/:path*"],
};
