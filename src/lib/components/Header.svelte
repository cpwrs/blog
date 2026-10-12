<header>
  <nav>
    <a class="title" href="/">carsonp.net</a>
  </nav>
</header>

<style>
  header {
    margin-bottom: 2ch;
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
      font-size: 1.3em;
      flex-grow: 2;
    }
  }
</style>
