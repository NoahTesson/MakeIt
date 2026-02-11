import { Router } from 'itty-router'

const router = Router()

// --- GROUPS ---

router.get('/groups', async (req, env) => {
	try {
		const data = await env.DB.prepare("SELECT * FROM Groups").all()
		return Response.json(data.results)
	} catch (e) {
		return Response.json({ status:'ko', error:e }, { status:500 })
	}
})

router.get('/groups/:id', async (req, env) => {
	try {
		const data = await env.DB.prepare("SELECT * FROM Groups WHERE id = ?")
			.bind(req.params.id).all()
		return Response.json(data.results[0] || {})
	} catch (e) {
		return Response.json({ status:'ko', error:e }, { status:500 })
	}
})

router.post('/groups', async (req, env) => {
	const { name, color } = await req.json() as any
	try {
		const result = await env.DB.prepare(
			"INSERT INTO Groups (name, color) VALUES (?, ?)"
		).bind(name, color).run()

		return Response.json(result.meta.last_row_id)
	} catch (e) {
		return Response.json({ status:'ko', error:e }, { status:500 })
	}
})

router.put('/groups/:id', async (req, env) => {
	const { name, color } = await req.json() as any
	try {
		await env.DB.prepare(
			"UPDATE Groups SET name = ?, color = ? WHERE id = ?"
		).bind(name, color, req.params.id).run()

		return Response.json({ status:'ok' })
	} catch (e) {
		return Response.json({ status:'ko', error:e }, { status:500 })
	}
})

router.delete('/groups/:id', async (req, env) => {
	try {
		await env.DB.prepare("DELETE FROM Groups WHERE id = ?")
			.bind(req.params.id).run()
		return Response.json({ status:'ok' })
	} catch (e) {
		return Response.json({ status:'ko', error:e }, { status:500 })
	}
})


// --- Task ---
router.get('/task', async (req, env) => {
	try {
		const result = await env.DB.prepare("SELECT * FROM Task").all()
		return Response.json(result.results)
	} catch (err) {
		return Response.json({ status:"ko", error:err }, { status:500 })
	}
})

router.get('/taskByGroup/:groupId', async (req, env) => {
	const id = req.params.groupId

	try {
		const result = await env.DB.prepare("SELECT * FROM Task WHERE groupId = ?").bind(id).all()

		return Response.json(result.results)
	} catch (err) {
		return Response.json({ status:"ko", error:err }, { status:500 })
	}
})

router.delete('/task/:id', async (req, env) => {
	const id = req.params.id

	try {
		const task = await env.DB.prepare(
			"SELECT * FROM Task WHERE id = ?"
		).bind(id).all()

		if (!task.results.length)
			return Response.json({ status:"ko", message:"Task not found" }, { status:404 })

		const { system, systemId } = task.results[0]

		switch (system) {
			case "None":
				break
			case "Timer":
				await env.DB.prepare("DELETE FROM Timer WHERE id = ?").bind(systemId).run()
				break
			case "SmartTimer":
				await env.DB.prepare("DELETE FROM SmartTimer WHERE id = ?").bind(systemId).run()
				break
			default:
				return Response.json({ status:"ko", message:"Invalid system" }, { status:400 })
		}

		await env.DB.prepare("DELETE FROM Task WHERE id = ?").bind(id).run()

		return Response.json({ status:"ok" })

	} catch (err) {
		return Response.json({ status:"ko", error:err }, { status:500 })
	}
})

router.put('/task/:id', async (req, env) => {
	const id = req.params.id
	const { groupId, system, name, recurrence, endDate } = await req.json() as any

	try {
		await env.DB.prepare(`
			UPDATE Task SET 
				groupId = ?, 
				system = ?, 
				name = ?,
				recurrence = ?, 
			WHERE id = ?
		`).bind(groupId, system, name, recurrence, endDate, id).run()

		return Response.json({ status:'ok' })
	} catch (err) {
		return Response.json({ status:'ko', error:err }, { status:500 })
	}
})


// --- None ---
router.post('/none', async (req, env) => {
	const { groupId, name, recurrence } = await req.json() as any

	try {
		const safeGroupId = (groupId === -1 || groupId === undefined) ? null : groupId

		const result = await env.DB.prepare(`
			INSERT INTO Task (groupId, name, system, systemId, recurrence)
			VALUES (?, ?, 'None', -1, ?)
		`).bind(safeGroupId, name, recurrence).run()

		return Response.json(result.meta.last_row_id)
	} catch (e) {
		console.log("error: ", e)
		return Response.json({ status:'ko', error: e }, { status:500 })
	}
})


// --- Timer ---
router.get('/timer/:id', async (req, env) => {
	const id = req.params.id

	try {
		const result = await env.DB.prepare("SELECT * FROM Timer WHERE id = ?").bind(id).run()

		return new Response(
			JSON.stringify(result.results[0]),
			{
				status: 200,
				headers: { "Content-Type": "application/json" }
			}
		);
	} catch (err) {
		console.error('❌ Erreur dans /getTasks :', err)
		return Response.json({
		status: 'ko',
		message: 'Erreur interne serveur',
		}, { status: 500 })
	}
})

router.post('/timer', async (request, env) => {
	const body = await request.json()
	const { groupId, name, recurrence, nbHours, nbMinutes, nbSeconds } = body as any

	try {
		const safeGroupId = (groupId === -1 || groupId === undefined) ? null : groupId

		const timer = await env.DB.prepare(`
			INSERT INTO Timer (nbHours, nbMinutes, nbSeconds)
			VALUES (?, ?, ?)
		`).bind(nbHours, nbMinutes, nbSeconds).run()

		const result = await env.DB.prepare(`
			INSERT INTO Task (groupId, name, system, systemId, recurrence)
			VALUES (?, ?, 'Timer', ?, ?)
		`).bind(safeGroupId, name, timer.meta.last_row_id, recurrence).run()

		return Response.json(result.meta.last_row_id )
	} catch (e) {
		return Response.json({ status:"ko", error:e }, { status:500 })
	}
})

router.put('/timer/:id', async (req, env) => {
	const id = req.params.id
	const body = await req.json() as any
	const { nbHours, nbMinutes, nbSeconds } = body

	try {
		await env.DB.prepare(
			`UPDATE Timer SET nbHours = ?, nbMinutes = ?, nbSeconds = ? WHERE id = ?
		`).bind(nbHours, nbMinutes, nbSeconds, id).run()

		return new Response(JSON.stringify({}), {
			status: 200,
			headers: { "Content-Type": "application/json" }
		});
	} catch (err) {
		console.error(err)
		return Response.json({ status: 'ko', message: 'Erreur serveur' }, { status: 500 })
	}
})


// --- SmartTimer ---
router.get('/smartTimer/:id', async (req, env) => {
	const id = req.params.id

	try {
		const result = await env.DB.prepare("SELECT * FROM SmartTimer WHERE id = ?").bind(id).run()

		return new Response(
			JSON.stringify(result.results[0]),
			{
				status: 200,
				headers: { "Content-Type": "application/json" }
			}
		);
	} catch (err) {
		console.error('❌ Erreur dans /getTasks :', err)
		return Response.json({
		status: 'ko',
		message: 'Erreur interne serveur',
		}, { status: 500 })
	}
})

router.post('/smartTimer', async (request, env) => {
	const body = await request.json()
	const { groupId, name, recurrence, nbRep, nbSeries, timeRecup } = body as any

	try {
		const safeGroupId = (groupId === -1 || groupId === undefined) ? null : groupId

		const st = await env.DB.prepare(`
			INSERT INTO SmartTimer (nbRep, nbSeries, currentRep, currentSeries, timeRecup)
			VALUES (?, ?, 0, 0, ?)
		`).bind(nbRep, nbSeries, timeRecup).run()

		const result = await env.DB.prepare(`
			INSERT INTO Task (groupId, name, system, systemId, recurrence)
			VALUES (?, ?, 'SmartTimer', ?, ?)
		`).bind(safeGroupId, name, st.meta.last_row_id, recurrence).run()

		return Response.json(result.meta.last_row_id)
	} catch (e) {
		return Response.json({ status:"ko", error:e }, { status:500 })
	}
})

router.put('/smartTimer/:id', async (req, env) => {
	const id = req.params.id
	const body = await req.json() as any
	const { currentRep, currentSeries } = body

	console.log("currentRep: ", currentRep)
	console.log("currentSeries: ", currentSeries)

	try {
		await env.DB.prepare(
			`UPDATE SmartTimer SET currentRep = ?, currentSeries = ? WHERE id = ?
		`).bind(currentRep, currentSeries, id).run()

		return new Response(JSON.stringify({}), {
			status: 200,
			headers: { "Content-Type": "application/json" }
		});	
	} catch (err) {
		console.error(err)
		return Response.json({ status: 'ko', message: 'Erreur serveur' }, { status: 500 })
	}
})



// --- Cron Test ---
router.get('/crontest', async (req, env) => {

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

	return Response.json({ status: 'ok' }, { status: 200 })
})

// Route catch-all 404
router.all('*', () => new Response('Not found', { status: 404 }))

export default router