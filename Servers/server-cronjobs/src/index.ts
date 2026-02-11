/**
 * Welcome to Cloudflare Workers!
 *
 * This is a template for a Scheduled Worker: a Worker that can run on a
 * configurable interval:
 * https://developers.cloudflare.com/workers/platform/triggers/cron-triggers/
 *
 * - Run `npm run dev` in your terminal to start a development server
 * - Run `curl "http://localhost:8787/__scheduled?cron=*+*+*+*+*"` to see your Worker in action
 * - Run `npm run deploy` to publish your Worker
 *
 * Bind resources to your Worker in `wrangler.jsonc`. After adding bindings, a type definition for the
 * `Env` object can be regenerated with `npm run cf-typegen`.
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

export default {
	async fetch(req) {
		const url = new URL(req.url);
		url.pathname = '/__scheduled';
		url.searchParams.append('cron', '* * * * *');
		return new Response(`To test the scheduled handler, ensure you have used the "--test-scheduled" then try running "curl ${url.href}".`);
	},

	// The scheduled handler is invoked at the interval set in our wrangler.jsonc's
	// [[triggers]] configuration.
	async scheduled(event, env, ctx): Promise<void> {

		const tasks = await env.DB.prepare(`SELECT * FROM Task`).run()

		for (const task of tasks.results) {
			if (task.system == "None") continue;
			if (task.recurrence !== "Chaquejour") continue;

			if (task.system == "SmartTimer") {
				const result = await env.DB.prepare(`SELECT * FROM SmartTimer WHERE id = ?`).bind(task.systemId).run()

				console.log("-----")
				console.log("Tâche:", task.name)
				console.log("currentSeries:", result.results[0].currentSeries)
				console.log("nbSeries:", result.results[0].nbSeries)

				if (result.results[0].currentSeries != result.results[0].nbSeries) {
					console.log("pas fini donc pas jour augmenter, retour a zero")
		
					await env.DB.prepare(`UPDATE Task SET inArow = 0 WHERE id = ?`).bind(task.id).run()

					await env.DB.prepare(`UPDATE SmartTimer SET currentRep = 0, currentSeries = 0 WHERE id = ?`).bind(task.systemId).run()
		
					console.log(`Tâche "${task.name}" réinitialisée (${task.type})`);
				} else {
					console.log("result2: ", task.inArow)
					console.log("${String(Number(result2) + 1)}: ", task.inArow + 1)
		
					await env.DB.prepare(`UPDATE Task SET inArow = ${String(Number(task.inArow) + 1)} WHERE id = ?`).bind(task.id).run()

					await env.DB.prepare(`UPDATE SmartTimer SET currentRep = 0, currentSeries = 0 WHERE id = ?`).bind(task.systemId).run()
		
					console.log(`Tâche "${task.name}" réinitialisée (${task.type})`);
				}
			}
		}
	},
} satisfies ExportedHandler<Env>;
