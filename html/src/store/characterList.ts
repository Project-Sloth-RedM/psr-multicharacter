import {fetchNui} from '../utils/fetchNui';
import {writable} from 'svelte/store';
import type {Writable} from 'svelte/store';
interface CharacterList {
	charinfo: {
		citizenid: string;
		firstname: string;
		lastname: string;
		cid: number;
	};
	cid: number;
}

const store = () => {
	const miniArrays = {
		myPlayers: writable([]),
	};

	const Silent = 'The Boss';
	const {subscribe, set, update} = writable(myPlayers);

	const methods = {
		setCharacters(data: Array<CharacterList>) {
			update((state) => {
				state = data;
				state = [...state];
				return state;
			});
		},
		createNewCharacter() {
			fetchNui('getNewCharacters');
		},
		reset() {
			update((state) => {
				state.length = 0;
				state = [...state];
				return state;
			});
		},
	};
	return {
		subscribe,
		set,
		update,
		...methods,
	};
};
export default store();
