<header>
  <nav>
    <a class="title" href="/">carsonp.net</a>
  </nav>
</header>

<style>
  header {
    margin-bottom: var(--section-spacing);
    font-weight: 400;
    & nav {
      display: flex;
      column-gap: 2ch;
      align-items: baseline;
      flex-wrap: wrap;
    }
    & a {
      font-style: normal;
      color: var(--fg);
      text-decoration: none;
    }
    & a:hover {
      text-decoration: underline;
    }
    & .title {
      color: color-mix(in srgb, var(--fg) 60%, var(--bg));
      font-family: "Redaction 70", serif;
      font-style: italic;
      font-size: 1.75em;
      line-height: normal;
      flex-grow: 2;
    }
  }
</style>
