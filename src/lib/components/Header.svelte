<script lang="ts">
  import { onMount } from "svelte";
  import moon from "$lib/moon.svg";
  import sun from "$lib/sun.svg";

  let dark = $state(false);

  onMount(() => {
    const preference = window.matchMedia("(prefers-color-scheme: dark)");
    const syncWithPreference = () => {
      if (!document.documentElement.dataset.theme) dark = preference.matches;
    };

    syncWithPreference();
    preference.addEventListener("change", syncWithPreference);

    return () => preference.removeEventListener("change", syncWithPreference);
  });

  function toggleTheme() {
    dark = !dark;
    document.documentElement.dataset.theme = dark ? "dark" : "light";
  }
</script>

<header>
  <nav>
    <a class="title" href="/">carsonp.net</a>
    <button
      type="button"
      class="theme-toggle"
      aria-label={dark ? "Switch to light mode" : "Switch to dark mode"}
      aria-pressed={dark}
      onclick={toggleTheme}
    >
      <span
        class="theme-icon"
        style={`--theme-icon: url("${dark ? sun : moon}")`}
        aria-hidden="true"
      ></span>
    </button>
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
      font-size: 1.5em;
      flex-grow: 2;
    }
    & .theme-toggle {
      display: grid;
      align-self: center;
      width: 2rem;
      height: 2rem;
      padding: 0.35rem;
      border: 0;
      color: var(--fg);
      background: transparent;
      cursor: pointer;
    }
    & .theme-icon {
      width: 100%;
      height: 100%;
      background: currentColor;
      mask: var(--theme-icon) center / contain no-repeat;
    }
  }
</style>
