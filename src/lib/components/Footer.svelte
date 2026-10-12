<script lang="ts">
  export let commit: string | null;
  import rss from "$lib/rss.svg";
  import git from "$lib/git.svg";
  import mail from "$lib/mail.svg";
</script>

<nav>
  <a href="mailto:carson@linux.com" aria-label="Email Carson">
    <span class="icon" style={`--icon: url("${mail}")`} aria-hidden="true"></span>
    <span class="email">Email</span>
  </a>
  <a
    href={commit
      ? `https://github.com/cpwrs/blog/tree/${commit}`
      : "https://github.com/cpwrs/blog"}
    aria-label={commit
      ? `View commit ${commit} on GitHub`
      : "View repository on GitHub"}
  >
    <span class="icon" style={`--icon: url("${git}")`} aria-hidden="true"></span>
    <span>Patch</span>
  </a>
  <a href="" aria-label="Subscribe to RSS">
    <span class="icon" style={`--icon: url("${rss}")`} aria-hidden="true"></span>
    <span>Subscribe</span>
  </a>
</nav>

<style>
  nav {
    display: flex;
    column-gap: 2ch;
    align-items: center;
    flex-wrap: wrap;
    justify-content: flex-start;
    font-style: bold;
    & a {
      display: flex;
      align-items: center;
      gap: 0.5ch;
      text-decoration: none;
    }
    & a:hover span {
      text-decoration: underline;
      position: relative;
    }
  }
  .icon {
    display: block;
    width: 1.5ch;
    height: 1.5ch;
    flex: none;
    background: currentColor;
    mask: var(--icon) center / contain no-repeat;
  }

  @media (max-width: 70ch) {
    nav a {
      gap: 0;
    }

    nav a span:not(.icon) {
      display: none;
    }
  }
</style>
