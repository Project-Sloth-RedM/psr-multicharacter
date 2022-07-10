import {fetchNui} from '../utils/fetchNui';
import {writable} from 'svelte/store';
import type {Writable} from 'svelte/store';

interface Character {
	firstname: string;
	lastname: string;
	gender: string;
	nationality: string;
	date: Date;
	cid: number;
}
interface CharacterList {
	charinfo: {
		citizenid: string;
		firstname: string;
		lastname: string;
		cid: number;
	};
	cid: number;
}
interface Data {
	charList: CharacterList;
	newChar: Character;
	openCharWindows: boolean;
	newCharAcceptButton: boolean;
}

const store = () => {
	const miniArrays = {
		charList: writable([{}]),
		newChar: writable({}),
		openCharWindows: writable(false),
		newCharAcceptButton: writable(false),
	};
	const {subscribe, set, update} = writable(miniArrays);
	const methods = {
		setCharacters(data: Array<CharacterList>) {
			miniArrays.charList.update((state) => {
				state = data;
				state = [...state];
				console.log(JSON.stringify(state));
				return state;
			});
		},
		reset() {
			miniArrays.charList.update((state) => {
				state.length = 0;
				state = [...state];
				return state;
			});
		},
		async createNewCharacter(data: Character) {
			miniArrays.newCharAcceptButton.set(true);
			await fetchNui('createCharacter', data).then((cb) => {
				if (cb) {
					miniArrays.newCharAcceptButton.set(false);
					miniArrays.openCharWindows.set(false);
				}
			});
		},
	};
	return {
		subscribe,
		set,
		update,
		...miniArrays,
		...methods,
	};
};
export default store();
