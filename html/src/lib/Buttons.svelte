<script lang="ts">
	export let text = '';
	export let onClick = (): void => {};
	export let checkEmptyData = true;
	export let type = 'accept';
</script>

<main>
	<div on:click={checkEmptyData && type === 'accept' ? null : onClick} class="container relative-position fit">
		<span class="absolute-center text-h4">
			{text}
		</span>
		<img class:disabled={checkEmptyData} class="imr" style:width="10vw" alt="" />
	</div>
</main>

<style>
	span {
		color: white;
	}
	.imr {
		content: url('../img/inputg.png');
		transition: content 0.5s;
	}
	.container:hover .imr {
		content: url('../img/inputb.png');
	}

	.container:hover span {
		transition: 0.1s;
		color: black;
	}
	.disabled {
		content: url('../img/namebg.png');
	}
</style>
