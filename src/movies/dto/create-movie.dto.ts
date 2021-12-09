import { IsNumber, IsString } from "class-validator";

export class createMovieDTO {

  @IsString()
  readonly title: string;

  @IsNumber()
  readonly year: number;

  @IsString({ each: true })
  readonly genres: string[];
}