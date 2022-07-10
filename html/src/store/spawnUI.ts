import {writable} from 'svelte/store';
interface SpawnUIData {
	coords: Object;
	location: string;
	label: string;
	canspawn: boolean;
}
const store = () => {
	const defaultSpawn = [
		{
			coords: {},
			location: 'lastlocation',
			label: 'Last Location',
			canspawn: true,
		},
	];
	const {subscribe, set, update} = writable(defaultSpawn);
	return {
		subscribe,
		set,
		update,
		addNewLocations: (locations) => {
			update((state) => {
				state = [...state, ...locations];
				return state;
			});
		},
		reset: () => {
			set(defaultSpawn);
		},
	};
};
export default store();
