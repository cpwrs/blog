<script lang="ts">
  export let commit: string | null;
  import rss from "$lib/rss.svg";
  import git from "$lib/git.svg";
  import mail from "$lib/mail.svg";
</script>

<nav>
  <a href="mailto:carson@linux.com">
    <img class="icon" src={mail} alt="Email Icon" />
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
    <img class="icon" src={git} alt="Git Logo" />
    <span>Patch</span>
  </a>
  <a href="">
    <img class="icon" src={rss} alt="RSS Logo" />
    <span>Subscribe</span>
  </a>
</nav>

<style>
  nav {
    display: flex;
    column-gap: 2ch;
    align-items: center;
    flex-wrap: wrap;
    justify-content: flex-end;
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
    width: 1.5ch;
  }

  @media (max-width: 70ch) {
    nav a {
      gap: 0;
    }

    nav a span {
      display: none;
    }
  }
</style>
