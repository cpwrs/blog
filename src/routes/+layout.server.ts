import { env } from '$env/dynamic/private';
import type { LayoutServerLoad } from './$types';

const GITHUB_USERNAME = 'cpwrs';
const ONE_DAY = 86400_000;

const QUERY = `
  query($userName:String!) {
    user(login: $userName){
      contributionsCollection {
        contributionCalendar {
          totalContributions
          weeks {
            contributionDays {
              contributionCount
              date
            }
          }
        }
      }
    }
  }
`;

let contributions: number[][] | null = null;
let fetchedAt: number | null = null;
let refreshPromise: Promise<number[][]> | null = null;

async function fetchGitHubContributions(): Promise<number[][]> {
  if (!env.GITHUB_TOKEN) {
    throw new Error('GITHUB_TOKEN is not set');
  }

  const response = await fetch('https://api.github.com/graphql', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${env.GITHUB_TOKEN}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      query: QUERY,
      variables: { userName: GITHUB_USERNAME },
    }),
  });

  if (!response.ok) {
    throw new Error(`GitHub API request failed: ${response.status}`);
  }

  const data = await response.json();

  const calendar =
    data.data?.user?.contributionsCollection?.contributionCalendar;

  if (!calendar) {
    throw new Error('GitHub API response did not include contribution calendar');
  }

  return calendar.weeks.map((week: any) =>
    week.contributionDays.map((day: any) => day.contributionCount),
  );
}

function refreshContributions(): Promise<number[][]> {
  refreshPromise ??= fetchGitHubContributions()
    .then((fresh) => {
      contributions = fresh;
      fetchedAt = Date.now();
      return fresh;
    })
    .finally(() => {
      refreshPromise = null;
    });

  return refreshPromise;
}

function getContributions(): number[][] | Promise<number[][] | null> | null {
  if (!env.GITHUB_TOKEN) {
    return null;
  }

  const stale =
    fetchedAt === null ||
    Date.now() - fetchedAt > ONE_DAY;

  if (!contributions) {
    return refreshContributions().catch((error) => {
      console.error('Failed to fetch GitHub contributions:', error);
      return null;
    });
  }

  if (stale) {
    void refreshContributions().catch((error) => {
      console.error('Failed to refresh GitHub contributions:', error);
    });
  }

  return contributions;
}

export const load: LayoutServerLoad = ({ setHeaders }) => {
  setHeaders({
    'cache-control': 'public, max-age=3600',
  });

  return {
    contributions: getContributions(),
  };
};
