import { PartialType } from "@nestjs/mapped-types";
import { IsNumber, IsOptional, IsString } from "class-validator";
import { createMovieDTO } from "./create-movie.dto";

export class updateMovieDto extends PartialType(createMovieDTO) {

  @IsString()
  readonly title?: string;

  @IsNumber()
  readonly year?: number;

  @IsOptional()
  @IsString({ each: true })
  readonly genres?: string[];
}