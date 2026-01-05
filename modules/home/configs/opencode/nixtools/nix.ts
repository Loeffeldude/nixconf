import { tool } from "@opencode-ai/plugin";

export const nixSearch = tool({
  description: "Query the nixpkgs",
  args: {
    query: tool.schema.string().describe("The package to search for"),
  },
  async execute(args) {
    const result = await fetch(
      "https://search.nixos.org/backend/latest-44-nixos-25.11/_search",
      {
        headers: {
          "Accept-Language": "en-US,en;q=0.5",
          Authorization:
            // TODO: this might change in the future i guess it's hard coded in
            // https://search.nixos.org/packages as of now
            "Basic YVdWU0FMWHBadjpYOGdQSG56TDUyd0ZFZWt1eHNmUTljU2g=",
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          from: 0,
          size: 50,
          sort: [
            {
              _score: "desc",
              package_attr_name: "desc",
              package_pversion: "desc",
            },
          ],
          aggs: {
            package_attr_set: {
              terms: { field: "package_attr_set", size: 20 },
            },
            package_license_set: {
              terms: { field: "package_license_set", size: 20 },
            },
            package_maintainers_set: {
              terms: { field: "package_maintainers_set", size: 20 },
            },
            package_teams_set: {
              terms: { field: "package_teams_set", size: 20 },
            },
            package_platforms: {
              terms: { field: "package_platforms", size: 20 },
            },
            all: {
              global: {},
              aggregations: {
                package_attr_set: {
                  terms: { field: "package_attr_set", size: 20 },
                },
                package_license_set: {
                  terms: { field: "package_license_set", size: 20 },
                },
                package_maintainers_set: {
                  terms: { field: "package_maintainers_set", size: 20 },
                },
                package_teams_set: {
                  terms: { field: "package_teams_set", size: 20 },
                },
                package_platforms: {
                  terms: { field: "package_platforms", size: 20 },
                },
              },
            },
          },
          query: {
            bool: {
              filter: [
                {
                  term: {
                    type: { value: "package", _name: "filter_packages" },
                  },
                },
                {
                  bool: {
                    must: [
                      { bool: { should: [] } },
                      { bool: { should: [] } },
                      { bool: { should: [] } },
                      { bool: { should: [] } },
                      { bool: { should: [] } },
                    ],
                  },
                },
              ],
              must_not: [],
              must: [
                {
                  dis_max: {
                    tie_breaker: 0.7,
                    queries: [
                      {
                        multi_match: {
                          type: "cross_fields",
                          query: args.query,
                          analyzer: "whitespace",
                          auto_generate_synonyms_phrase_query: false,
                          operator: "and",
                          _name: "multi_match_test",
                          fields: [
                            "package_attr_name^9",
                            "package_attr_name.*^5.3999999999999995",
                            "package_programs^9",
                            "package_programs.*^5.3999999999999995",
                            "package_pname^6",
                            "package_pname.*^3.5999999999999996",
                            "package_description^1.3",
                            "package_description.*^0.78",
                            "package_longDescription^1",
                            "package_longDescription.*^0.6",
                            "flake_name^0.5",
                            "flake_name.*^0.3",
                          ],
                        },
                      },
                      {
                        wildcard: {
                          package_attr_name: {
                            value: `*${args.query}*`,
                            case_insensitive: true,
                          },
                        },
                      },
                    ],
                  },
                },
              ],
            },
          },
        }),
        method: "POST",
        mode: "cors",
      },
    );

    if (!result.ok) {
      throw new Error("Search returned error");
    }

    const json = await result.json();

    return JSON.stringify(json.hits.hits.map((h) => h._source));
  },
});
