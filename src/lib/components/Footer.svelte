<script lang="ts">
  export let commit: string | null;
  import rss from "$lib/rss.svg";
  import git from "$lib/git.svg";
  import mail from "$lib/mail.svg";
</script>

<!-- {#if commit} -->
  <nav>
    <a href="mailto:carson@linux.com">
      <img class="icon" src={mail} alt="Email Icon" />
      <span class="email">carson@linux.com</span>
    </a>
    <a
      href="https://github.com/cpwrs/blog/tree/{commit}"
      aria-label="View commit {commit} on GitHub"
    >
      <img class="icon" src={git} alt="Git Logo" />
      <span>Source</span>
    </a>
    <a href="">
      <img class="icon" src={rss} alt="RSS Logo" />
      <span>Feed</span>
    </a>
  </nav>
<!-- {/if} -->

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
      align-items: baseline;
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
</style>
