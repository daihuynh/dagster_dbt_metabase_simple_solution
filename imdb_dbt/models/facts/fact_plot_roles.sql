WITH RECURSIVE PlotRoles(id, role, rest, round) AS (
    SELECT nconst, primaryProfession, primaryProfession || ',', 1
    FROM (SELECT nconst, primaryProfession FROM {{ ref('valid_plots') }} )
    UNION ALL
    SELECT id
        , substr(rest, 0, instr(rest, ','))
        , substr(rest, instr(rest, ',')+1)
        , round + 1
    FROM PlotRoles
    WHERE role <> ''
), PlotInfo AS (
	SELECT id AS plot_id
		, role
	FROM PlotRoles
	WHERE role <> '' AND round > 1
)
SELECT (plot_id || '-' || role) AS plot_role_key
	, *
FROM PlotInfo